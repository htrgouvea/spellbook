# Bruteforce Modules

### Introduction

The `bruteforce` category contains modules focused on authentication attacks, password spraying, or credential testing against known services.

These modules should be used carefully and only within an explicitly authorized scope.

### Current modules

- `Bruteforce::Facebook`
- `Bruteforce::Instagram`
- `Bruteforce::JWT_Secret`
- `Bruteforce::Linkedin`
- `Bruteforce::SMTP`
- `Bruteforce::Tomcat`
- `Bruteforce::Twitter`
- `Bruteforce::Wordpress`

### Typical use cases

- test weak credentials
- validate password spray workflows
- verify exposed login interfaces
- check JWT weak-secret scenarios

### Notes

- some modules support single credentials and list-based attacks
- wordlists under `files/` are often relevant to this category
- this category is naturally sensitive and should be used with strict scope control
