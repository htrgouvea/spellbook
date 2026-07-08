# Flow Based Programming

### Introduction

Spellbook uses a Flow Based Programming style to keep modules small, reusable, and easy to compose.

In classical FBP terms, an application is built from independent components that exchange messages through well-defined connections. In Spellbook, those components are usually Perl packages under `lib/Spellbook`, and the messages are usually array references shaped like command-line arguments.

This is one of the main reasons Spellbook can treat modules as interchangeable building blocks instead of large tightly coupled commands.

### What FBP means in Spellbook

In Spellbook, the practical interpretation of FBP is:

- one package represents one focused capability
- a package receives a message
- the package parses that message
- the package performs one operation
- the package returns plain values
- those returned values can be reused by another package

This gives the project a component-oriented structure without needing a large object model.

### Message format

The common Spellbook message format is an array reference that looks like CLI arguments.

Examples:

```perl
['--target' => 'example.com']
['--file' => 'targets.txt']
['--help']
['--target' => 'example.com', '--threads' => 10]
```

Each module usually owns its own parsing through `Getopt::Long::GetOptionsFromArray`.

Example:

```perl
Getopt::Long::GetOptionsFromArray(
    $parameters,
    'h|help'     => \$help,
    't|target=s' => \$target,
);
```

This makes the same module callable from:

- `spellbook.pl`
- another Spellbook module
- `Core::Orchestrator`
- a test or syntax check
- a small standalone Perl script

### Execution model

Most Spellbook modules follow a simple execution shape:

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

The important idea is not the exact syntax. The important idea is that the package behaves like a self-contained processing node.

### Return model

Spellbook modules usually return plain Perl values rather than printing directly or managing a long-lived object state.

Common patterns are:

```perl
return @results;             # multiple results
return $value;               # one result
return 0;                    # no result, invalid input, or skipped path
return "\n[!] message\n";    # user-facing message
```

This matters because the caller decides what to do with the output:

- print it
- filter it
- deduplicate it
- pass it to another module
- run the same module against many inputs

### Composition

Composition is where the FBP style becomes useful.

One module can call another module by sending it a message in the same internal format:

```perl
my @items = Spellbook::Helper::Read_File->new([
    '--file' => $wordlist,
]);

my @results = Spellbook::Recon::Host_Resolv->new([
    '--target' => $target,
]);
```

The modules do not need a custom integration layer because they already speak the same message format.

This is also the idea behind `Core::Orchestrator`, which applies one module to many targets in parallel while preserving the same execution model.

### Why this style fits Spellbook

This style is useful in Spellbook because many security tasks naturally look like small transformations:

- read a list
- normalize the input
- enrich the target
- check a condition
- return findings

FBP makes these tasks easier to split into smaller parts and then recombine without rewriting them.

### Design rules used here

The practical rules used in Spellbook are:

- keep modules focused on one capability
- prefer a single execution entrypoint, usually `new`
- accept message-style parameters instead of custom calling conventions
- return values instead of forcing output side effects
- move reusable behavior into another package when the logic starts to grow too much

This keeps modules easier to search, test, and reuse.

### Important nuance

Spellbook follows an FBP-inspired style, not a rigid academic implementation of every FBP concept.

In practice:

- most modules use one main execution subroutine
- most modules are message-driven
- some modules may still contain small internal helpers
- the main goal is composability, not purity

So the value of the pattern is architectural consistency, not strict dogma.

### Related documents

- [Core Overview](./core-overview.md)
- [Core Module Loader](./core-module-loader.md)
- [Core Orchestrator](./core-orchestrator.md)
- [Module Authoring](./module-authoring.md)
