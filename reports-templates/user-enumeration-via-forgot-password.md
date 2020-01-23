## User Enumeration via Forgot Password

### Summary

Hi $target Team,
I found a vulnerability that allows an attacker to enumerate the users present on your platform. This vulnerability is based on the "I forgot my password" field, where a malicious user can take advantage of the page's feedback messages to enumerate users.

Well, we have two behaviors on this page:

1 - When a valid email is provided on this page, it returns feedback saying that an email has been sent to this user.

2 - When an invalid email is provided on this page, it returns feedback saying that the user does not exist on the platform.

Based on this, an attacker can automate this type of request and enumerate in a massive way which users are present on the platform, opening a surface for him to execute other types of attacks.

### Impact

The impact here is that an attacker can enumerate users registered on the platform and use that information to carry out other types of more elaborate attacks in the future.

### Mitigation

Add rate limit on the application.
Use CAPTCHA verification if many request is sent.

### Referencies

You can also gain many information by visiting:
https://www.gnucitizen.org/blog/username-enumeration-vulnerabilities/
https://portswigger.net/blog/preventing-username-enumeration