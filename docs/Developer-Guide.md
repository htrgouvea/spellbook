# Developer Guide

This guide covers how to develop and test Spellbook.

For a walkthrough of building new modules, see the project
[wiki](https://github.com/htrgouvea/spellbook/wiki/Developer-Guide).

## Running the tests

The unit tests live in the `tests/` directory and use Perl's standard
`Test::More` framework. After installing the dependencies, run the whole suite
with `prove`:

```bash
$ prove -lr tests/
```

Any test whose optional dependency is not installed is skipped rather than
failed, so the suite is safe to run in a minimal environment. The same command
runs automatically on every push through the `test-on-ubuntu` workflow.

## Writing tests

Tests currently cover the `Spellbook::Core::*` modules. Each module has a
dedicated file under `tests/` (for example `tests/core-helper.t`), and
`tests/00-load.t` checks that every Core module compiles.

When you add a test:

- Name the file `tests/<area>-<module>.t`.
- Add `lib/` to `@INC` (the existing files use `FindBin`) and `chdir` to the
  repository root if the module reads files such as `.config/modules.json`.
- If the module relies on an optional CPAN prerequisite, guard the test with
  `plan skip_all` when that prerequisite is missing, following the pattern in
  the existing files, so the suite stays green in a minimal environment.
