# Core Orchestrator

### Introduction

`Core::Orchestrator` is the component responsible for executing one module against many targets in parallel.

This is useful when a target list already exists and the same module should be applied to each item. In practice, this is one of the clearest examples of the reusable and composable approach used by Spellbook.

### Supported input sources

The orchestrator can receive targets from:

- a wordlist file through `--wordlist`
- an in-memory list through `--list`

The module to execute is provided through `--entrypoint`.

### Execution model

Internally, the orchestrator:

```text
1. Parses the input arguments
2. Creates a queue of targets
3. Spawns worker threads
4. Runs Core::Module for each target
5. Deduplicates results
6. Returns the final result list
```

The current default thread count is `10`.

### Notes

- The orchestrator forwards `--target` plus the original parameter list to the selected module
- Results are deduplicated before being returned
- The current implementation uses Perl threads, `Thread::Queue`, and shared variables

### Related components

- [Core Module Loader](./core-module-loader.md)
- [Core CLI Flow](./core-cli-flow.md)
