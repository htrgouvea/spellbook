<p align="center">
  <img src="https://heitorgouvea.me/images/projects/spellbook/logo.png" width="150px" height="150px">
  <h3 align="center"><b>Spellbook</b></h3>
  <p align="center">A micro-framework for rapid development of reusable security tools</p>
  <p align="center">
    <a href="https://github.com/htrgouvea/spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/htrgouvea/spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.0.7-blue.svg">
    </a>
  </p>
</p>

---

### Summary

Here you will find a "spellbook" with my personal scripts, exploits and other small things I wrote during my bug hunting jorney, pentesting or red teaming missions. Like any other spellbook, some things here are not going to be very easy to understand, but like any other spellbook it couldn't be different, right?

The main focus of this "micro-framework" is to keep my personal scripts organized and make them available in a structure where I can reuse the code that has already been written to write something else. Furthermore, the Spellbook is just a research project that so far is no big deal and does not replace a truly robust framework.

---

### Download and install

```
  # Download
  $ git clone https://github.com/htrgouvea/spellbook && cd spellbook

  # Install libs and dependencies
  $ cpan install Getopt::Long Mojo::File Mojo::JSON
```

---

### How to use

```
Spellbook v0.0.7
Core Commands
==============
	Command          Description
	-------          -----------
	-s, --search     List modules, you can filter by category
	-m, --module     Set a module to use
	-t, --target     Set a target
	-p, --parameter  Set a value for a module parameter
```

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/htrgouvea/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)