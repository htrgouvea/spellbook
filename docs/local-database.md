# Local Database

### Introduction

To keep things simpler, Spellbook does not use a database engine. Instead, it stores structured data in `.json` files. At the moment, the main files are:

```text
# Responsible for storing all module information: name, category, id, description
.config/modules.json

# Responsible for storing API keys for platforms like Shodan, Hunter.io, and others
.config/credentials.json
```

Working with these files avoids extra code, reduces unnecessary resource consumption, and keeps setup simpler.

For the current Spellbook context this works well, though another solution may be needed in the future.

### Managing credentials

Credentials can be managed through `Core::Credentials`. You only need to inform the platform to query information, or the platform plus its value when writing or updating data.

```bash
$ perl spellbook.pl -m Core::Credentials --help

Core::Credentials
==============
-h, --help       See this menu
-p, --platform   Read some credentials filtering by platform
-v, --value      Define a value of a platform
```

```bash
$ perl spellbook.pl -m Core::Credentials -p shodan -v "YourAPIKeyHere"

Value updated
```

```bash
$ perl spellbook.pl -m Core::Credentials -p shodan

YourAPIKeyHere
```

More details about this behavior are documented in [Core Credentials](./core-credentials.md).

---

### Managing modules

The module registry is stored in [.config/modules.json](../.config/modules.json). Each entry describes a module by id, category, module name, and description.

This file is used by the core to:

- list modules through `Core::Search`
- resolve module names through `Core::Module`
- expose the available building blocks of the framework

When creating a new module, remember that the JSON entry and the Perl package path must match. For example, a module declared with category `recon` and module name `Find_Emails` is expected to exist at `lib/Spellbook/Recon/Find_Emails.pm`.

For more details about this loading flow, see [Core Module Loader](./core-module-loader.md).

---
