<p align="center">
  <img src="https://heitorgouvea.me/images/projects/spellbook/logo.png" width="150px" height="150px">
  <h2 align="center">Spellbook</h2>
  <p align="center">My collection of custom scripts, plugins, exploits and others small things</p>
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

### Download & Install

```bash 
    # Cloning
    git clone https://github.com/GouveaHeitor/spellbook && cd spellbook
    
    # Building image
    $ docker build --rm --squash -t spellbook .

    # Using this container
    $ docker run -v /root/home:/home/ -p 1337:1337 -p 9090:9090 -ti spellbook /bin/bash
```

---

### Tools

  Name | Category | Description | Link
  ---- | ---- | ---- | ----
  hunter.pl | Recon | Extract all e-mails collected by hunter.io | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/hunter.pl)
  extract_links.pl | Recon | A simple script to extrack urls from a webpage | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/extract_links.pl)
  bing.pl | Recon | ------ | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/bing.pl)
  shodan.pl | Recon | ------ | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/shodan.pl)
  github.pl | Recon | ------ | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/github.pl)
  pastebin.pl | Recon | ------ | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/pastebin.pl)
  zoomeye.pl | Recon | ------ | [View](https://github.com/GouveaHeitor/spellbook/blob/master/recon/zoomeye.pl)

---


### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](https://github.com/GouveaHeitor/spellbook/blob/master/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/GouveaHeitor/spellbook/issues) and for security issues, see here the [security policy.](https://github.com/GouveaHeitor/spellbook/blob/master/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---
 
### License

- This work is licensed under [MIT License.](https://github.com/GouveaHeitor/spellbook/blob/master/LICENSE.md)
