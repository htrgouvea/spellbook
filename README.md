<p align="center">
  <h3 align="center">Security Spellbook</h3>
  <p align="center">My collection of custom scripts, plugins, exploits and others small things</p>

  <p align="center">
    <a href="https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/security-spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.1-blue.svg">
    </a>
  </p>
</p>

---

### Download & Install

```bash 
    git clone https://github.com/GouveaHeitor/security-spellbook
    cd security-spellbook

    # building image
    $ docker build --rm --squash -t kali .

    # create alias command
    $ alias kali='docker run -p 8080:8080 -p 1337:1337 -v /Users/$(whoami)/Documents/:/home/ -ti kali /bin/bash'

    # stop containers
    $ docker stop $(docker ps -a -q)

    # remove containers
    $ docker rm $(docker ps -a -q)
```

### Contribution

- Your contributions and suggestions are heartily♥ welcome. [**See here the contribution guidelines.**](/.github/CONTRIBUTING.md) Please, report bugs via [**issues page.**](https://github.com/GouveaHeitor/security-spellbook/issues)(✿◕‿◕) 

### License

- This work is licensed under [**MIT License.**](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)
