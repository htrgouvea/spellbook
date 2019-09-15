<p align="center">
  <h3 align="center">Security Spellbook</h3>
  <p align="center">My collection of pentesting and bug bounty hunting tricks/scripts</p>

  <p align="center">
    <a href="https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/security-spellbook/releases">
      <img src="https://img.shields.io/badge/version-0.1-blue.svg">
    </a>
    <a href="https://twitter.com/GouveaHeitor">
      <img src="https://img.shields.io/badge/twitter-@GouveaHeitor-blue.svg">
    </a>
  </p>
</p>

---

```
    [+] AUTOR:        Heitor Gouvêa
    [+] EMAIL:        hi@heitorgouvea.me
    [+] WEBSITE:      https://heitorgouvea.me
    [+] GITHUB:       https://github.com/GouveaHeitor
```

### Install

```bash 
    git clone https://github.com/GouveaHeitor/security-spellbook
    cd security-spellbook

    # building image
    $ docker build --rm --squash -t kali .

    # create alias command
    $ alias kali='docker run -p 1337:1337 -v /Users/$(whoami)/Documents/Workstation:/home/ -ti kali /bin/bash'
```


### Workflow's

---
Recon Workflow

![Recon Workflow](files/recon-workflow.jpeg)

---

AWS Workflow

<p align="center"> 
    <img src="files/aws-s3-workflow.jpg">
</p>

---

### Tricks

```bash
    # enumarate subdomains
    $~ for subdomain in $(cat wordlists/subdomains.txt);do ruby network/check.rb ${subdomain}target.com; done

    # port scanning
    $~ for port in {1..65535}; do perl network/portscan.pl target.com $port; done

    # range scanning
    $~ for host in {21..25}; do perl network/portscan.pl 104.24.111.${host} 80; done

    # links extract
    $~ perl web/links.pl https://target.com

    # admin finder
    $~ perl web/adminfinder.pl https://target.com

    # backdoor access
    $~ perl network/backdoor.pl # agent
    $~ nc 127.0.0.1 21666       # client
```

### Notes

```bash
    $ docker stop $(docker ps -a -q)
    $ docker rm $(docker ps -a -q)
```

### Bugs

- Report bugs via [**issues page.**](https://github.com/GouveaHeitor/security-spellbook/issues)

### License

- This work is licensed under [**MIT License**](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)

### Contribution

- Your contributions and suggestions are heartily♥ welcome. (✿◕‿◕) [**See here the contribution guidelines**](/.github/CONTRIBUTING.md)
