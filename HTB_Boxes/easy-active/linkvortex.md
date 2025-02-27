# LinkVortex

# Nmap

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

Looking at the site we see it is powered by ghost 5.58 and we also find a robots.txt file. We can note that this version of ghost is vulnerable to this [exploit](https://github.com/0xDTC/Ghost-5.58-Arbitrary-File-Read-CVE-2023-40028). But we need credentials first...

We find a login page at [http://linkvortex.htb/ghost/#/signin](http://linkvortex.htb/ghost/#/signin)

Looking at the subdomains we find a dev.linkvortex.htb. On this domain we find a server-status page will brute forcing but we get a 403 when we try to access it. I got stuck in a rabbit hole of trying to spoof my IP to gain access to gain access but then I took a step back ran an nmap scan and found a .git repo.

Let's download the repo with git-dumper and serach for the string "password" and we get a huge amount of results but we filter out anything that is not a js file and then manually look around at interesting looking file names and find credentials in a authentication.test.js file. Let's try these on the login page we found earlier.

The credentials are for email test@example.com. But this email does not work... and in the git repo the only other email is for dev@linkvortex.htb which also doesnt work. But after some manual guessing we find and email that does worl! And we log in!!

Lets try that exploit linked above. And we are able to read files!! After a little googling i decide to read the /var/lib/ghost/config.production.json file and find ssh credentials for bob!

# Priv esc

Running sudo -l we find an interesting command that we can run at root. By creating symbolic links we can exploit it to read the root flag... This is not really priv esc but we get the flag anyway.

PWNDDD
