# Maprisma add-ons

The signed add-ons of [Maprisma](https://maprisma.com): the agent and local LLM adapters and the
online providers, as data (Maprisma loads no add-on code). Maprisma fetches `catalog.json` and
`catalog.sig` from this repository's main branch and checks every signature with the author's key
built into the app; only add-ons signed by Uwe Bruckhaus are offered and loaded.

- `tools/release-adapters.sh`: builds the adapters from a Maprisma checkout
  (`tools/build-adapter-addons.py`, `MAPRISMA=<checkout>`, default `../maprisma`), signs each one
  (`~/.ssh/maprisma-addons`, namespace `maprisma-addon`; the passphrase is asked once), zips them and
  writes `dist/adapters-<version>.zip` for the packages.
- `tools/release.sh <folder>`: signs one add-on and the catalog.
- `tools/publish.sh`: the GitHub releases and the catalog (only with Uwe's go-ahead).

Maprisma was called Asterism until 2026-10-30; the add-ons of the Asterism releases stay in
`uBruckhaus/asterism-addons`.
