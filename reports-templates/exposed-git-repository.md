## Publicly accessible Git Repository Directory

### Summary

Hi $target Team,

I found an exposed git repository. Git metadata directory (.git) was found in this folder. An attacker can extract sensitive information by requesting the hidden metadata directory that version control tool Git creates. The metadata directories are used for development purposes to keep track of development changes to a set of source code before it is committed back to a central repository (and vice-versa). When code is rolled to a live server from a repository, it is supposed to be done as an export rather than as a local working copy, and hence this problem.

This endpoint could allow an attacker to retrieve much of the source code and git history for this service which could potentially reveal sensitive information like application secrets.

### Steps to reproduce

    [1] - Open: https://target.com/.git

[ ! ] These files may expose sensitive information that may help an malicious user to prepare more advanced attacks.

### Impact

The impact is obvious here. As you can see, the vulnerability is about information leakage of the $target. This endpoint could allow an attacker to retrieve much of the source code and git history for this service which could potentially reveal sensitive information like application secrets.

### Mitigation

Remove the directory or access it.

### Referencies

You can also gain many information by visiting:
https://en.internetwache.org/dont-publicly-expose-git-or-how-we-downloaded-your-websites-sourcecode-an-analysis-of-alexas-1m-28-07-2015/