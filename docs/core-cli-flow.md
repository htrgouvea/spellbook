# Core CLI Flow

### Introduction

Spellbook starts at [spellbook.pl](../spellbook.pl). This file is responsible for parsing the top-level flags and routing execution to the correct core component.

### Main arguments

The current top-level arguments are:

- `--search`: search modules in the local registry
- `--module`: execute a specific module

If neither argument is provided, Spellbook falls back to `Core::Helper` and prints the main help menu.

### Execution flow

The main function follows this order:

```text
1. Parse --search and --module
2. If --search is present, call Core::Search
3. If --module is present, call Core::Module
4. Print all returned results
5. If no top-level action was requested, show Core::Helper
```

This design keeps the CLI entrypoint small and moves the actual behavior to reusable modules inside `lib/Spellbook/Core`.

### Notes

- Module-specific options are not parsed in `spellbook.pl`
- Remaining arguments are forwarded to the selected module
- This allows each module to define its own interface independently
