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

---

### Summary

⚠️ __Warning:__ Spellbook is currently in __development__, you've been warned :) and please consider [contributing!](./github/CONTRIBUTING.md)

Here you will find a "spellbook" with my personal scripts, exploits and other small things I wrote during my bug hunts, pentesting or red teaming missions. Like any other spellbook, some things here are not going to be very easy to understand, but like any other spellbook it couldn't be different, right?

The main focus of this "micro-framework" is to keep my personal scripts organized and make them available in a structure where I can reuse the code that has already been written to write something else. Furthermore, the Spellbook is just a research project that so far is no big deal and does not replace a truly robust framework.

---

### Download and install

```
  $ git clone https://github.com/GouveaHeitor/spellbook && cd spellbook
  $ cpan install Getopt::Long Mojo::File Mojo::JSON
```

---

### How to use

```bash
Spellbook v0.0.4
Core Commands
==============
	Command       Description
	-------       -----------
	--show        List modules, you can filter by category
	--module      Set a module to use
	--read        Read the code of a module
```

### Examples

```bash
# You can use the --show option to list the available modules
# valid parameters: all, recon, exploit, auxiliary or parser
$ perl spellbook.pl --show recon

Module: Recon::Find_Emails
Category: recon
Description: Find e-mails from a domain using hunter.io API
=================================================


Module: Recon::Passive_Enum
Category: recon
Description: Enumerate ports and service from a IP using Shodan API
=================================================
...

# To use a module, you can use the -m option followed by the name of the module
# followed by -t which is the main entry point of the module
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

### How to create new modules

First, you need to specify your module in the list of packages that Spellbook reads, present in: **.config/modules.json**

![](https://heitorgouvea.me/images/projects/spellbook/example_packages-json.png)

Just copy the last block of the json and insert the information of the new module;

Second, all modules are stored and accessible through the lib/Modules folder, each module is organized in a third folder that defines its category, such as:

![](https://heitorgouvea.me/images/projects/spellbook/list-modules.png)

Find the folder for the specific category of your module, or create one, then you can create your module normally like any other Perl module.

The only premise is that your module receives a main entry point and returns the results in an array.

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/GouveaHeitor/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)
