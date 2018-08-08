# Security spellbook

My collection of information security tricks/scripts

[![MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)
---

```
    [+] AUTOR:        Heitor Gouvêa
    [+] EMAIL:        hi@heitorgouvea.me
    [+] WEBSITE:      https://heitorgouvea.me
    [+] GITHUB:       https://github.com/GouveaHeitor
    [+] TELEGRAM:     @GouveaHeitor
```

##### Install

```bash
    git clone https://github.com/GouveaHeitor/security-spellbook
    cd security-spellbook
    ./setup.sh
```

##### Tricks

```bash
    # enumare subdomains
    $~ for subdomain in $(cat wordlists/subdomains.txt);do perl network/check.pl ${subdomain}target.com; done

    # port scanning
    $~ for port in {1..65535}; do perl network/portscan.pl target.com $port; done

    # range scanning
    $~ for host in {21..25}; do perl network/portscan.pl 104.24.111.${host} 80; done

    # backdoor agent
    $~ perl network/backdoor.pl # open connection
    $~ nc 127.0.0.1 21666       # connect
```

##### Bugs

- Report bugs in my email: **hi@heitorgouvea.me**

##### License

- This work is licensed under [**MIT License**](https://github.com/GouveaHeitor/security-spellbook/blob/master/LICENSE.md)

##### Contribution

- Your contributions and suggestions are heartily♥ welcome. (✿◕‿◕)[**See here the contribution guidelines**](/.github/CONTRIBUTING.md)

##### Disclaimer

I do private jobs, if you are interesting send me an e-mail at: **hi@heitorgouvea.me**
