<p align="center">
  <h3 align="center">Security Spellbook</h3>
  <p align="center">My collection of custom scripts, plugins, exploits and others small things</p>

  <p align="center">
    <a href="https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/security-spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.1.3-blue.svg">
    </a>
  </p>
</p>

---

### Download & Install

```bash 
    git clone https://github.com/GouveaHeitor/security-spellbook
    cd security-spellbook

    # Building image
    $ docker build --rm --squash -t kali .

    # Using this container
    $ docker run -p 1337:1337 -p 9090:9090 -ti kali /bin/bash
```

### Content

  Tool |  Category | Description | Link
  ---- | ---- | ---- | ----
  verbshttp.pl | Fuzzing | A tool to fuzzing all HTTP verbs | [View]()
  hunter.pl | Recon | Extract all e-mails collected by hunter.io | [View](/recon/hunter.pl)

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page.](https://github.com/GouveaHeitor/security-spellbook/issues) See here the [security policy.](./SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).
 
### License

- This work is licensed under [MIT License.](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)
