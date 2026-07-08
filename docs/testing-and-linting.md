# Testing and Linting

### Introduction

Spellbook currently has a lightweight verification workflow based on dependency installation, basic CLI smoke testing, Perl::Critic, and external static analysis in CI.

### Current CI checks

Based on the repository workflows, the current checks include:

- Perl::Critic via `.github/workflows/linter.yml`
- a basic Ubuntu smoke test via `.github/workflows/test-on-ubuntu.yml`
- ZARN static analysis via `.github/workflows/zarn.yml`

### Local dependency install

The standard install path is:

```bash
cpanm --installdeps .
```

On Ubuntu, the CI workflow also installs system packages before Perl dependencies:

```bash
sudo apt-get update
sudo apt-get install -y perl cpanminus build-essential libdatetime-perl libssl-dev libexpat1-dev libpcap-dev masscan
sudo cpanm --installdeps .
```

### Local smoke checks

A minimal local verification flow is:

```bash
perl spellbook.pl --help
perl spellbook.pl --search recon
```

If you are changing a specific module, a practical extra step is:

```bash
perl -Ilib -c lib/Spellbook/Category/Module.pm
```

### Linting

The project uses `.perlcriticrc` for Perl::Critic configuration.

A local lint command is:

```bash
perlcritic --profile .perlcriticrc . | grep -v "source OK"
```

### Practical notes

- the current CI smoke test is intentionally small
- syntax checks with `perl -Ilib -c` are useful when editing individual modules
- Perl::Critic is the main style and static quality gate visible in the repository
- ZARN provides an additional static security analysis layer in CI
