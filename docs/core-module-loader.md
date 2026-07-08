# Core Module Loader

### Introduction

`Core::Module` is responsible for translating a user-provided module name such as `Recon::Find_Emails` into a Perl package and executing it.

### Resolution flow

The loader works as follows:

```text
1. Read .config/modules.json through Core::Resources
2. Iterate over all declared modules
3. Build the full name as <Category>::<Module>
4. Compare that value with the requested module
5. require the matching Perl file from lib/Spellbook
6. Call Spellbook::<Category>::<Module>->new(...)
7. Filter undefined or zero-like results
```

This means the local registry is the source of truth for what Spellbook can execute.

### Example

If the registry contains:

```json
{
    "category": "recon",
    "module": "Find_Emails"
}
```

Then `Core::Module` will resolve the request `Recon::Find_Emails` to:

```text
Spellbook::Recon::Find_Emails
```

And it will load the file:

```text
lib/Spellbook/Recon/Find_Emails.pm
```

### Practical implications

- Declaring a module in `.config/modules.json` is mandatory
- The category and module name must match the Perl package path
- The `new` method is the execution entrypoint for modules
- Returned values are collected and printed by the main CLI
