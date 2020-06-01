<p align="center">
  <img src="https://heitorgouvea.me/images/projects/spellbook/logo.png" width="150px" height="150px">
  <h2 align="center">Spellbook</h2>
  <p align="center">A micro-framework for rapid development of reusable security tools</p>
  <p align="center">
    <a href="https://github.com/GouveaHeitor/spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.0.3-blue.svg">
    </a>
  </p>
</p>

⚠️ __Warning:__ Spellbook is currently in __development__, you've been warned :) and please consider [contributing](./github/CONTRIBUTING.md)

---

### Summary

Here you will find a "spellbook" with my personal scripts, exploits and other small things I wrote during my bug hunts, pentesting or red teaming missions. Like any other spellbook, some things here are not going to be very easy to understand, but it couldn't be different, right?

---

### Usage

```bash
Spellbook v0.0.3
Core Commands
==============
	Command       Description
	-------       -----------
	--show        List modules, you can filter by category
	--module      Set a module to use
	--read        Read the code of a module
	--output      Create a output file
```

### Examples

```bash
$ perl spellbook.pl --show recon

Name: find_emails
Category: recon
Description: Find e-mails from a domain using hunter.io API
Package: Recon::Find_Emails
=================================================


Name: passive_enum
Category: recon
Description: Enumerate ports and service from a IP using Shodan API
Package: Recon::Passive_Enum
=================================================
...

$ perl spellbook.pl -m Recon::Find_Emails -t github.com

stanleygoldman@github.com
bryanmacfarlane@github.com
rob.rix@github.com
rschultheis@github.com
pedrolacerda@github.com
jonahberquist@github.com
brendan@github.com
michaelsainz@github.com
acadavid@github.com
patrick.reynolds@github.com
```

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/GouveaHeitor/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)
