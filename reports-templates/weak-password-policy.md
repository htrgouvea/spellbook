## Weak Password Policy

### Summary:

Hi $target Team,

I find a problem related to your password policy, it is weak and does not incorporate the basic security principles, making room for others attacks types.

### Steps To Reproduce:

    1. - Navigate to signup page; [https://$target.com]
    2. - Fill your details and give password as simple as: 12345;
    3. - As you can see, you will be registered and there is no strong enforcement.

### Impact

This password can easily be cracked using dictionary attack. I recognize that the login area has a recapctha mechanism, which does not allow a brute force attack. However, this mechanism may fail, or be the victim of a new bypass. In addition, this password is also stored, so if there is a leak, it may be the victim of an offline attack;

### Mitigation

Use a complex password policy. For example: it requires that all passwords have at least 8 characters, in addition to requiring a combination of uppercase and lowercase letters and numbers.

### References:

https://cwe.mitre.org/data/definitions/521.html
https://www.owasp.org/index.php/Testing_for_Weak_password_policy_(OTG-AUTHN-007)