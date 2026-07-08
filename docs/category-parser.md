# Parser Modules

### Introduction

The `parser` category contains modules focused on extracting structured data from existing artifacts.

Instead of probing a live target directly, these modules usually receive a file, URL, or serialized document and return extracted values.

### Current modules

- `Parser::Nmap`
- `Parser::Nozaki`
- `Parser::S3_Bucket`
- `Parser::Sitemap`

### Typical use cases

- extract open ports from Nmap XML
- parse sitemaps and bucket listings
- transform raw data sources into reusable target lists

### Notes

- parser modules are often a good bridge between external tooling and Spellbook workflows
- the returned values can usually be reused by recon or exploit modules
