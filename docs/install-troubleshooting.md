# Install Troubleshooting

### Introduction

Spellbook depends on several Perl modules and a few system-level packages. When installation fails, the root cause is usually one of three things:

- missing system libraries
- missing build tools
- a Perl dependency failing to compile or resolve

### Recommended install path

Start with the standard repository command:

```bash
cpanm --installdeps .
```

If you are on Ubuntu or a similar Debian-based system, the CI workflow uses:

```bash
sudo apt-get update
sudo apt-get install -y perl cpanminus build-essential libdatetime-perl libssl-dev libexpat1-dev libpcap-dev masscan
sudo cpanm --installdeps .
```

### Common issues

#### 1. `cpanm` is missing

Install it first:

```bash
sudo apt-get install -y cpanminus
```

#### 2. SSL or network-related Perl modules fail to build

Make sure OpenSSL development headers are installed:

```bash
sudo apt-get install -y libssl-dev
```

This is especially relevant for modules that depend on HTTPS support.

#### 3. XML or parser-related dependencies fail

Install XML-related development packages:

```bash
sudo apt-get install -y libexpat1-dev
```

#### 4. Packet capture or scanner dependencies fail

Some modules rely on packages that may need native compilation support or external binaries such as `masscan`.

On Ubuntu, the CI setup installs:

```bash
sudo apt-get install -y build-essential libpcap-dev masscan
```

#### 5. A module compiles in CI but not locally

Try a direct syntax check with the local library path:

```bash
perl -Ilib -c lib/Spellbook/Core/Module.pm
```

This avoids false failures caused by a missing `@INC` path.

#### 6. Credentials-dependent modules fail at runtime

Check whether `.config/credentials.json` contains the required API key for the platform used by that module.

### Practical notes

- use the CI workflow as the source of truth for the expected Ubuntu setup
- install failures are often environmental rather than project-specific
- when a single module is failing, test that file directly before assuming the whole project is broken

### Related documents

- [Testing and Linting](./testing-and-linting.md)
- [Local Database](./local-database.md)
