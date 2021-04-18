### Developing new modules

You need to specify your module in the list of Spellbook modules, present in: .config/modules.json; Just copy the last block of the json and insert the information of the new module;

```json
{
    "modules": [
        {
            "id": "0001",
            "category": "recon",
            "module": "Find_Emails",
            "description": "Find e-mails from a domain using hunter.io API",
        },
        {
            "id": "0002",
            "category": "exploits",
            "module": "CVE_2017_5487",
            "description": "Read usernames leaked on WordPress API",
        },
...
```

All modules are stored and accessible through the lib/Spellbook folder, each module is organized in a third folder that defines its category, such as:

```
.
├── Core
│   ├── Credentials.pm
│   ├── Helper.pm
│   ├── Module.pm
│   └── Search.pm
├── Exploits
│   ├── CVE_2006_3392.pm
│   └── CVE_2017_5487.pm
├── Helpers
│   ├── Exifs.pm
│   └── New_Target.pm
└── Recon
    ├── Bing.pm
    ├── Extract_Links.pm
    ├── Find_Emails.pm
    ├── Get_IP.pm
    ├── Host_Resolv.pm
    └── Passive_Enum.pm
```

As for the code you need to follow a basic structure which is:

```perl
package Spellbook::Core::Name {
    use strict;
    use warnings;

    sub new {
        my ($self, $target, $parameter) = @_;
        my @result = ();
        # Your code
        return @result;
    }
}

1;
```