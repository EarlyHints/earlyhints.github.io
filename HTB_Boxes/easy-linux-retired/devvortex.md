---
description: 10.10.11.242
---

# Devvortex

## Nmap

<figure><img src="../.gitbook/assets/image (52).png" alt=""><figcaption></figcaption></figure>

### Site enumeration

On the site nothing seem that interesting... After some enumeration with ffuf and gobuster i find a dev subdomain. It a joomla site

I followed this [guide ](https://hackertarget.com/attacking-enumerating-joomla/)on joomla enumeration and found the version 4.2.6 in use> I then found this [exploit ](https://github.com/Acceis/exploit-CVE-2023-23752)![](<../.gitbook/assets/image (47).png>)user: lewis password: P4ntherg0t1n5r3c0n##

We are now logged in. We get a notification that we are using php version 7.4.3 which is old....

Following this [guide ](https://anshildev.medium.com/wordpress-and-joomla-reverse-shells-f76dcdbc0339)we inject a reverse shell into the template file and can get a reverse shell!

Looking around we a mysql user in /etc/passwd let's try log in with the lewis creds from before. It hangs for a very long time...... And crashes I try again but to no avail so i restart the box and repeat all the steps and it works this time. Quite annoying...

In the sql database we find creds for logan and we use hashcat to crack the password: tequieromucho

We can use this as ssh credentials and get the user flag!

Running sudo -l we can run apport-cli as sudo googling we find [this](https://github.com/diego-tella/CVE-2023-1326-PoC) and we get the flag!

PAWNEDD
