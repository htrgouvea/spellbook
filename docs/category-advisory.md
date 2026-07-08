# Advisory Modules

### Introduction

The `advisory` category contains modules oriented around known CVEs or named vulnerability cases.

Compared with the generic `exploit` category, these modules are usually tied to a specific published issue or product weakness.

### Current modules

- `Advisory::CVE_2006_3392`
- `Advisory::CVE_2016_10045`
- `Advisory::CVE_2017_5487`
- `Advisory::CVE_2020_9376`
- `Advisory::CVE_2020_9377`
- `Advisory::CVE_2021_24891`
- `Advisory::CVE_2021_41174`
- `Advisory::CVE_2021_41773`
- `Advisory::CVE_2023_29489`
- `Advisory::CVE_2023_38646`
- `Advisory::CVE_2024_4040`
- `Advisory::Laravel_Ignition_XSS`
- `Advisory::RCE_Apache_Flink`

### Typical use cases

- validate exposure to a known CVE
- reproduce a published check or exploit path
- support focused testing against a known technology stack

### Notes

- input requirements vary widely because each advisory is specific to one issue
- many advisory modules expose a `--target` parameter and additional CVE-specific options
