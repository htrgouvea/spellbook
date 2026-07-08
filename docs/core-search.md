# Core Search

### Introduction

`Core::Search` is responsible for listing modules registered in `.config/modules.json` based on a user-provided search term.

This is the component used by:

```text
perl spellbook.pl --search <term>
```

### Data source

The search logic depends on `Core::Resources`, which reads the local module registry from `.config/modules.json`.

Each module entry contains fields such as:

- `id`
- `category`
- `module`
- `description`

### Search behavior

`Core::Search` iterates over every module entry and checks the search term against every field in that entry.

In practice, this means a query can match:

- the module id
- the category
- the module name
- the description

The comparison is case-insensitive.

### Output format

When a match is found, the current implementation prints:

```text
Module: <Category>::<Module>
Description: <description>
=================================================
```

This makes category-based searches especially useful when exploring what Spellbook can do.

### Practical notes

- `category` is usually the best filter for broad discovery
- `description` is useful when looking for a capability rather than a specific module name
- because the search checks every field, very short terms can produce noisy results
