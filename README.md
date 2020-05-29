<p align="center">
  <img src="https://heitorgouvea.me/images/projects/spellbook/logo.png" width="150px" height="150px">
  <h2 align="center">Spellbook</h2>
  <p align="center">A micro-framework for rapid development of reusable security tools</p>
  <p align="center">
    <a href="https://github.com/GouveaHeitor/spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.2-blue.svg">
    </a>
  </p>
</p>

---

### Summary

Here you will find a "spellbook" with my personal scripts, exploits and other small things I wrote during my bug hunts, pentesting or red teaming missions. Like any other spellbook, some things here are not going to be very easy to understand, but it couldn't be different, right?

---

### Usage

```bash
Spellbook v0.0.1
Core Commands
==============
	Command       Description
	-------       -----------
	--show        List modules, you can filter by category
	--module      Set a module to use
	--read        Read the code of a module
	--output      Create a output file

Copyright Spellbook (c) 2020 | Heitor Gouvêa
```

### Examples

```bash
$ perl spellbook.pl --show recon

...
Name: extract_links
Category: recon
Description: A module to extract links from a page
Package: Recon::Extract_Links
=================================================
...

$ perl spellbook.pl -m Recon::Extract_Links -t https://heitorgouvea.me

/images/favicon.ico
//fonts.googleapis.com/css?family=Inconsolata:400,700&subset=latin-ext,vietnamese
/css/main.css
https://heitorgouvea.me/
/
/projects
/about
/2020/01/03/From-Open-Redirect-to-Session-Token-Leak
https://twitter.com/GouveaHeitor
https://github.com/GouveaHeitor
```

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/GouveaHeitor/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)
