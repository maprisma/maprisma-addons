#!/bin/sh
# The agent and provider adapters as signed add-ons: generated from the Maprisma checkout
# (tools/build-adapter-addons.py there: data only, addon.json + agent.toml for an agent), then each one
# signed, zipped and put into the catalog by tools/release.sh. The passphrase is asked once: the key
# goes into an ssh-agent started for this run only.
#   tools/release-adapters.sh           MAPRISMA=<checkout> (default ../maprisma), KEY=<private key>
# Also dist/adapters-<version>.zip: all of them in one archive for the Maprisma packages.
set -eu
cd "$(dirname "$0")/.."
maprisma=${MAPRISMA:-../maprisma}
key=${KEY:-$HOME/.ssh/maprisma-addons}
python3 "$maprisma/tools/build-adapter-addons.py" .
# An agent of its own (never the session's): the key is gone when the run ends.
eval "$(ssh-agent -s)" >/dev/null
trap 'ssh-agent -k >/dev/null' EXIT
ssh-add -q "$key"
for folder in agent-*/ llm-*/ providers-online/; do
    KEY="$key.pub" sh tools/release.sh "${folder%/}"     # the public key: ssh-keygen signs through the agent
done
# One archive with all of them for the Maprisma packages (AppImage build.sh, AUR PKGBUILD): a release
# asset adapters-<version>.
version=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['version'])" agent-claude/addon.json)
python3 tools/zip_bundle.py "dist/adapters-$version.zip" agent-*/ llm-*/ providers-online/
sha256sum "dist/adapters-$version.zip"
