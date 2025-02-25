# Keeper

## Nmap scan

<figure><img src="../.gitbook/assets/image (24).png" alt=""><figcaption></figcaption></figure>

## Site enumeration

We find a login page on the site

<figure><img src="../.gitbook/assets/image (26).png" alt=""><figcaption></figcaption></figure>

We can play around with common passwords and find that root: password gets us authenticated as root!!

Once logged in we can see this page.

<figure><img src="../.gitbook/assets/image (27).png" alt=""><figcaption></figcaption></figure>

We can see a user name of lnorgaard and a defual password of Welcome2023!

This gives us access to ssh and we get the user flag!

## Priv esc

Linpeas doesnt show us anything interesting.

But there is a zip file containing a keepass dump in the home directory. We can copy it over to our desktop with scp.

After some googling we can dump the password for this file with this [github poc](https://github.com/vdohney/keepass-password-dumper)

And we get the password of "rødgrød med fløde" this gives us access to the keepass directory. Where we see the following credentails

<figure><img src="../.gitbook/assets/image (28).png" alt=""><figcaption></figcaption></figure>

I try to login with ssh but fail!!

It seems we need to have an id\_rsa file to authenticate

```
puttygen putty -O private-openssh -o id_rsa
```

Running this and then chmoding it generates a usable key and we have root!!!
