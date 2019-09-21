### Summary

Hi $target Team,

I have found a vulnerability by which an attacker can get access of all the emails accounts associated with $target. The forgot password parameter can be brute forced through which an attacker can get the email address.

### Steps to reproduce

  1. - Enter your email address and for the forgot password parameter.
  2. - Capture the request in the proxy.
  3. - Brute for the parameter using different email address.
  4. - Check the different request and see the response.

[ ! ] The right email and the wrong email will have different response and request length. Hence, the attack is successful.

### Impact

The impact is obvious here. As you can see, the vulnerability is about the email address leakage of the $target accounts.
The email address leakage of the account is said to be prohibited. The confidential data of the $target application can be leaked.


### Mitigation

Add rate limit on the application.
Use CAPTCHA verification if many request is sent.

### Referencies

You can also gain many information by visiting:
https://www.gnucitizen.org/blog/username-enumeration-vulnerabilities/
https://portswigger.net/blog/preventing-username-enumeration