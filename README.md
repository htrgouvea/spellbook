<p align="center">
  <h3 align="center">Security Spellbook</h3>
  <p align="center">My collection of custom scripts, plugins, exploits and others small things</p>

  <p align="center">
    <a href="https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/security-spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.1.2-blue.svg">
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

    # Create alias command
    $ alias kali='docker run -p 8080:8080 -p 1337:1337 -ti kali /bin/bash'

    # Use this container
    $ kali

    # Stop container
    $ docker stop kali

    # Remove container
    $ docker rm kali
```

Tool |  Description
---- | ----
fuzzing/verbshttp.pl | A tool to fuzzing all HTTP verbs in a Target

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [**See here the contribution guidelines.**](/.github/CONTRIBUTING.md) Please, report bugs via [**issues page.**](https://github.com/GouveaHeitor/security-spellbook/issues) See here the [**security policy.**](./SECURITY.md) (✿ ◕‿◕) 

### License

- This work is licensed under [**MIT License.**](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)
