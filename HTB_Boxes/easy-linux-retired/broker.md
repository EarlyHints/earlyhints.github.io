# Broker

# Nmap scan

<figure><img src="../.gitbook/assets/image (34).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

We get promted with a basic auth we can try admin: admin and get access. Easy!

We are now on an ActiveMQ page on msfconsole there are some modules on this but none of them seemed to work for me instead I used this [https://github.com/evkl1d/CVE-2023-46604](https://github.com/evkl1d/CVE-2023-46604)

And we get a shell!!!

# Priv esc

We can run sudo -l and find we can run nginx as root. Screenshotted bellow you can find the steps to exploit this to generate an ssh key as root

<figure><img src="../.gitbook/assets/image (64).png" alt=""><figcaption></figcaption></figure>

And we can use the key and get root!!!

PWNNDDD
