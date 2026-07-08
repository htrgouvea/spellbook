# Module Authoring

### Introduction

This guide explains the common structure used by Spellbook modules and how a new module should fit into the current codebase.

For the design model behind these conventions, see [Flow Based Programming](./flow-based-programming.md).

### Basic checklist

When creating a new module, the usual steps are:

```text
1. Create the Perl module under lib/Spellbook/<Category>/
2. Define the package as Spellbook::<Category>::<Name>
3. Implement the new method
4. Parse module-specific arguments
5. Return values as a list
6. Add the module metadata to .config/modules.json
```

### Typical structure

A Spellbook module usually follows this pattern:

```perl
package Spellbook::Recon::Example {
    use strict;
    use warnings;
    use Getopt::Long;

    our $VERSION = '0.0.1';

    sub new {
        my ($self, $parameters) = @_;
        my ($help, $target, @results);

        Getopt::Long::GetOptionsFromArray(
            $parameters,
            'h|help'     => \$help,
            't|target=s' => \$target,
        );

        if ($target) {
            # Your code here
            push @results, $target;
            return @results;
        }

        if ($help) {
            return "\n"
                . "Recon::Example\n"
                . "==============\n"
                . "-h, --help     See this menu\n"
                . "-t, --target   Define a target\n\n";
        }

        return 0;
    }
}

1;
```

### Conventions used in the project

- modules expose their behavior through `new`
- module arguments are usually parsed with `Getopt::Long::GetOptionsFromArray`
- help text is commonly returned when `--help` is provided
- successful execution usually returns a list of values
- `0` is commonly used when there is no result or no valid execution path

This is the common Spellbook pattern, even if a few modules may still contain small internal helper routines.

### Registry requirements

Every module must also be declared in `.config/modules.json`.

Example:

```json
{
    "id": "9999",
    "category": "recon",
    "module": "Example",
    "description": "Describe what the module does"
}
```

The package path, JSON metadata, and user-facing module name must stay aligned.

### Design notes

Because Spellbook treats modules as reusable building blocks, it is usually better for a module to:

- accept a clear input such as `--target`
- do one focused operation well
- return values that can be reused by other modules
- keep side effects limited and predictable

This makes the module easier to search, execute, and compose through the core components.

### Related documents

- [Flow Based Programming](./flow-based-programming.md)
- [Developer Guide](./Developer-Guide.md)
- [Core Module Loader](./core-module-loader.md)
- [Core Orchestrator](./core-orchestrator.md)
