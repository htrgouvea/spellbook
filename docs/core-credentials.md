# Core Credentials

### Introduction

`Core::Credentials` is responsible for reading and updating local credentials stored in `.config/credentials.json`.

This allows Spellbook modules to reuse API keys and platform tokens without hardcoding them inside the module code.

### Storage format

The credentials file is a JSON object where each key is the platform name and each value is the stored secret.

Example:

```json
{
    "hunter": "your-hunter-key",
    "security-trails": "your-security-trails-key",
    "shodan": "your-shodan-key"
}
```

### Supported operations

`Core::Credentials` supports two main actions:

- read a value for one platform
- create or update a value for one platform

Examples:

```text
$ perl spellbook.pl -m Core::Credentials -p shodan
```

```text
$ perl spellbook.pl -m Core::Credentials -p shodan -v "YourAPIKeyHere"
```

### Behavior

The current implementation:

```text
1. Parses --platform and --value
2. Reads .config/credentials.json
3. Decodes the JSON object
4. If --value is present, updates the selected key
5. Writes the JSON back to disk
6. Returns the stored value for that platform
```

### Practical notes

- platform names are used exactly as provided
- updates replace the previous value for the same key
- the credentials file is local to the repository
- modules that depend on external services can read their credentials through this shared storage

### Related documents

- [Local Database](./local-database.md)
- [Core Overview](./core-overview.md)
