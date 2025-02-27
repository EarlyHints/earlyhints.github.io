# Blocky

# Nmap scan

<figure><img src="../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

# Exploitation

We can see an old version of ProFTP I find this [exploit ](https://www.exploit-db.com/exploits/49908)but it does not work

Lets look on the site. There is a wordpress login form that leaks real usernames looking around on the site we can see it is minecraft themed with mentions of notch. And thats a valid username!! But even after running wpscan and creating a custom minecraft brute force password list I can't get the password. Also there are no interesting vulnerablities mentioned by wpscan

Lets brute force with ffuf and we find this page.

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

Downloading this file we can extract a password as follows

<figure><img src="../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

And this password and the notch username work on ssh. And we get the user flag!!!

# Priv esc

Running sudo -l we see we can run all commads as root ?!!?!!

<figure><img src="../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

That was easy..............
