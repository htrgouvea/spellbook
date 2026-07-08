# Helper Modules

### Introduction

The `helper` category contains utility modules that support other workflows inside Spellbook.

These modules are useful for data preparation, small transformations, and glue logic between other modules.

### Current modules

- `Helper::CDN_Checker`
- `Helper::Exifs_Write`
- `Helper::Generate_UUID`
- `Helper::Host_Normalization`
- `Helper::Permutations`
- `Helper::Domain_Permutations`
- `Helper::Read_File`
- `Helper::Reverse_Shell`
- `Helper::Scope`
- `Helper::Uniq`

### Typical use cases

- generate targets or identifiers
- generate close domain permutations for typo and lookalike checks
- normalize input data
- read wordlists or feed one module into another
- perform small supporting actions during security assessments

### Notes

- helper modules are often the easiest building blocks to compose
- `Helper::Read_File` is especially useful when feeding line-based input to another module
- `Helper::Domain_Permutations --resolve` marks a permutation as `unavailable` when DNS resolution succeeds and `available` when it does not resolve
- `Helper::Domain_Permutations --monitor` ranks lookalike domains for defensive monitoring with `domain`, `status`, `risk`, `score`, `similarity`, `entropy_delta`, and `reason` fields; resolved `unavailable` domains are prioritized before unresolved domains
- helper modules are a good place to keep reusable behavior out of exploit or recon modules
