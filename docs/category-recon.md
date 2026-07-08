# Recon Modules

### Introduction

The `recon` category contains modules focused on asset discovery, passive and active enumeration, URL collection, and target profiling.

This is currently one of the largest Spellbook categories and is usually the starting point for mapping a target before deeper testing.

### Current modules

- `Recon::Broken_Links`
- `Recon::DNS_Bruteforce`
- `Recon::DNS_Bruteforce_Filtered`
- `Recon::Detect_Error`
- `Recon::Dorking`
- `Recon::Extract_Links`
- `Recon::FavIcon`
- `Recon::Find_Emails`
- `Recon::Get_IP`
- `Recon::HTTP_Probe`
- `Recon::HaveBeenPwned`
- `Recon::Host_Resolv`
- `Recon::Internal_DNS`
- `Recon::Masscan`
- `Recon::Nmap_Scanner`
- `Recon::Passive_Links`
- `Recon::Public_DNS`
- `Recon::Query_Shodan`
- `Recon::Shodan_Enumeration`
- `Recon::Subdomain_Enumeration`
- `Recon::Subdomain_Scraper`
- `Recon::Technologies`
- `Recon::WayBackUrls`
- `Recon::Wildcard_Detection`

### Typical use cases

- discover subdomains and URLs
- resolve targets and inspect DNS behavior
- profile web technologies
- retrieve historical paths
- enrich targets with external APIs such as Shodan or SecurityTrails

### Notes

- some modules are passive, while others actively interact with the target
- some modules depend on credentials stored in `.config/credentials.json`
- recon modules are often good candidates to combine with `Core::Orchestrator`
