# User Guide

## Table of contents

- [Introduction](#introduction)
- [Searching by modules](#searching-by-modules)
- [Using modules](#using-modules)
- [Concatenating modules](#concatenating-modules)

### Introduction

This manual aims to illustrate how a common user, such as a Pentester or Red Teamer, can make use of Spellbook. If you want a deeper understanding of the project or want to develop new features, see the [Developer Guide](./Developer-Guide.md).

---

### Searching by modules

As Spellbook is based on modules, it has a local database where it stores information about all available modules. Searches can currently be performed by name, id, description, or category. In practice, category is usually the most effective filter.

Examples of searches:

```text
$ perl spellbook.pl --search exploit

Module: Exploit::CVE_2017_5487
Description: Read usernames leaked on WordPress API
=================================================

Module: Exploit::Shellshock
Description: Exploit for shellshock vuln
=================================================

Module: Exploit::Subdomain_Takeover_Check
Description: A checker for the possibility of subdomain takeover attack
=================================================

[...]
```

```text
$ perl spellbook.pl --search recon

Module: Recon::Find_Emails
Description: Find e-mails from a domain using hunter.io API
=================================================

Module: Recon::Get_Headers
Description: Get all HTTP headers from an web server
=================================================

Module: Recon::Extract_Links
Description: A module to extract all links from a web page
=================================================

[...]
```

Currently registered categories include `advisory`, `android`, `bruteforce`, `cloud`, `core`, `crypto`, `exploit`, `helper`, `parser`, `platform`, `recon`, and `utils`.

---

### Using modules

After identifying a module, it can be executed with the `--module` parameter. Each module exposes its own options through `--help`.

Example:

```text
$ perl spellbook.pl --module Advisory::CVE_2006_3392 --help

Advisory::CVE_2006_3392
=======================
-h, --help     See this menu
-t, --target   Define a target
-f, --file     Define a file to read
```

Once the target options are known, the module can be executed directly:

```text
$ perl spellbook.pl --module Advisory::CVE_2006_3392 -t http://127.0.0.1:10000/ -f /etc/passwd
```

In practice, Spellbook forwards the remaining command-line arguments to the selected module, so each module is responsible for parsing its own flags.

---

### Concatenating modules

Spellbook modules can also be combined when one module returns values that are useful as input to another one. This pattern is part of the FBP approach used by the project.

A common example is using one module to generate or extract targets and another module to process each returned value. This is the role of `Core::Orchestrator`, which can execute a module against a wordlist or a list of targets in parallel.

For developer details about this flow, see [Core Orchestrator](./core-orchestrator.md).

---
