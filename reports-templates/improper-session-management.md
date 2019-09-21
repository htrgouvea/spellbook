## Improper Session Management

### Summary:

Hi $target Team,

I found a problem related to your session management, it is weak and does not incorporate the basic security principles, making room for others attacks types.

This vulnerability boils down to: you can authenticate to the same account on more than one device at a time, without prompting the user for permission. This device may have another operating system, another version and even another IP.

### Steps To Reproduce:

    [1] - Download the application on two physical devices, being different from each other;
    [2] - Preferably, you are using different "networks" for each of them;
    [3] - Authenticate on one device and then on the other;
    [4] - Okay, you're logged in to the same account, but on two devices totally different from each other;

### Mitigation

Some good mitigation models used are:

Only allow one device at a time to access the account;
After registering the first device, the second must be authorized by the user, via email or by some other method;

Several other national banks act this way.

### Impact

An attacker who achieves the user's credentials can log in to the account and do malicious activity without the user even knowing that his account is being used in another device!

### References:

https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Session_Management_Cheat_Sheet.md