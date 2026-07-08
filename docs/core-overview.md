# Core Overview

### Introduction

The core of Spellbook is responsible for receiving command-line arguments, resolving modules from the local registry, executing those modules, and returning results to the user.

At a high level, the execution flow is:

```text
spellbook.pl
  -> Core::Helper
  -> Core::Search
  -> Core::Module
       -> Core::Resources
       -> Spellbook::<Category>::<Module>
```

When working with large target sets, `Core::Orchestrator` can also be used to dispatch a module across many inputs in parallel.

### Main components

- `spellbook.pl`: main CLI entrypoint
- `Core::Helper`: prints the top-level help menu
- `Core::Search`: searches the local module registry
- `Core::Resources`: reads `.config/modules.json`
- `Core::Module`: resolves and executes a selected module
- `Core::Credentials`: reads and updates `.config/credentials.json`
- `Core::Orchestrator`: runs modules in parallel against many targets

### Related documents

- [Core CLI Flow](./core-cli-flow.md)
- [Core Module Loader](./core-module-loader.md)
- [Core Orchestrator](./core-orchestrator.md)
- [Local Database](./local-database.md)
