# AATsy (sry)

Things:

- Automating the build process: `rake db:build`
  - Relies on preprocessing the TSVs to make them ingestible — still tk as rake task

- Using Rails to bootstrap a CLI lol
  - See `Subject.console_search` and `colorize` gem

- The ES `suggest` query
  - See `Subject` `mappings` as well as `#as_indexed_json`, `#suggestions`, `.complete`

- `Ancestry` gem for hierarchies as materialized paths
  - See how simple it makes

- Palette outside of JS

- Very handy to just log out all ES queries based on env var

- DIY accessible-ish autocomplete in 50 LOC
