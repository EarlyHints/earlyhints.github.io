# BoardLight

# Nmap

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

We don't find much on the site but I find and email with a domain board.htb so i add that to hosts and brute force subdomains and we find crm.board.htb.

There is a page with a Dolibarr 17.0.0 login we find a nice little exploit on [github](https://github.com/nikn0laty/Exploit-for-Dolibarr-17.0.0-CVE-2023-30253) but we need credentails first... Lets try the default admin: admin and we get in. Let's run the exploit!

And we get a shell! Looking arounf we find a config file with a password. Look at /etc/passwd we find the user larissa lets try this user pass combo on ssh. We are in!!

# Priv esc

We have some mysql credentials so lets log in. Looking around nothin sticks out so lets abandon this path. I can't find anything off so lets use linpeas. We find enlightenmet that looks interestinng

It is version 0.23.1 we find an exploit on github upload it to the ssh and gain root. Very easy...

PWNDDD
