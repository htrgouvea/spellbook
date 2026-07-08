# Developer Guide

## Introduction

This manual aims to illustrate how a low-level user, such as a Developer or Security Researcher, can make use of Spellbook. If you want a simpler, user-focused overview, see the [User Guide](./user-guide.md).

For architecture details about the project core, start with [Core Overview](./core-overview.md).

The architectural model behind Spellbook is documented in [Flow Based Programming](./flow-based-programming.md).

## Developing new modules

You need to declare your module in the Spellbook module list stored at [.config/modules.json](../.config/modules.json). Copy an existing JSON block and insert the metadata for the new module.

```json
{
    "modules": [
        {
            "id": "0001",
            "category": "recon",
            "module": "Find_Emails",
            "description": "Find e-mails from a domain using hunter.io API"
        },
        {
            "id": "0002",
            "category": "exploit",
            "module": "CVE_2017_5487",
            "description": "Read usernames leaked on WordPress API"
        }
    ]
}
```

All modules are stored under `lib/Spellbook`. Each module is organized inside a folder that defines its category, for example:

```text
lib/Spellbook
├── Core
│   ├── Credentials.pm
│   ├── Helper.pm
│   ├── Module.pm
│   └── Search.pm
├── Exploit
│   ├── CVE_2006_3392.pm
│   └── CVE_2017_5487.pm
├── Helper
│   ├── Exifs_Write.pm
│   └── Reverse_Shell.pm
└── Recon
    ├── Extract_Links.pm
    ├── Find_Emails.pm
    ├── Get_IP.pm
    ├── Host_Resolv.pm
    └── Passive_Links.pm
```

As for the code, modules generally follow a basic structure like this:

```perl
package Spellbook::Core::Name {
    use strict;
    use warnings;

    sub new {
        my ($self, $target, $parameter) = @_;
        my @result = ();
        # Your code
        return @result;
    }
}

1;
```

In practice, most modules also parse their own arguments through `Getopt::Long::GetOptionsFromArray`, return lists of values, and expose a `--help` menu when called without the required arguments.

The core loading path is documented in [Core Module Loader](./core-module-loader.md).

For a more concrete writing guide, see [Module Authoring](./module-authoring.md).

## Running the tests

The unit tests live in the `tests/` directory and use Perl's standard
`Test::More` framework. After installing the dependencies, run the whole suite
with `prove`:

```bash
$ prove -lr tests/
```

Any test whose optional dependency is not installed is skipped rather than
failed, so the suite is safe to run in a minimal environment. The same command
runs automatically on every push through the `test-on-ubuntu` workflow.

## Writing tests

Tests currently cover the `Spellbook::Core::*` modules. Each module has a
dedicated file under `tests/` (for example `tests/core-helper.t`), and
`tests/00-load.t` checks that every Core module compiles.

When you add a test:

- Name the file `tests/<area>-<module>.t`.
- Add `lib/` to `@INC` (the existing files use `FindBin`) and `chdir` to the
  repository root if the module reads files such as `.config/modules.json`.
- If the module relies on an optional CPAN prerequisite, guard the test with
  `plan skip_all` when that prerequisite is missing, following the pattern in
  the existing files, so the suite stays green in a minimal environment.
