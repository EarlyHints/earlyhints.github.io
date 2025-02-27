# Antique

# Nmap

<figure><img src="../.gitbook/assets/image (44).png" alt=""><figcaption></figcaption></figure>

UDP scan

<figure><img src="../.gitbook/assets/image (45).png" alt=""><figcaption></figcaption></figure>

# Exploitation

This is an odd one. We can see is running a telnet server for whqat seems to be a printer and there is an snmp server as well. After some digging we can find this [vulnerability ](https://www.exploit-db.com/exploits/22319)in the JetAdmin service.

We cab exploit it as follows

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

We now has a string we need to decode and I make a quick script in python

<figure><img src="../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

And we get this password: P@ssw0rd@123!!123

We can now authenticate to telnet running help we can see we can exec commands lets start a reverse shell

<figure><img src="../.gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

And boom we have user!!!

# Priv esc

Lets run Linpeas. We find the following open port.

<figure><img src="../.gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (11).png" alt=""><figcaption></figcaption></figure>

It seems to be a cups server. But with just our shell session we can't really see much. So I create a proxy with chisel and am able to see the site locally and it looks like this.

<figure><img src="../.gitbook/assets/image (12).png" alt=""><figcaption></figcaption></figure>

After some googling we can find this versions of cups is vulnerable to **CVE-2012-5519**

There is a msf paylaod for this but I could not get it working. Basically this idea is we can leak files by setting the logFile location to be somewhere sensetive. Since this is a HTB box we know we want root/root.txt so let's exploit this manually

```
cupsctl ErrorLog=/root/root.txt
curl 127.0.0.1:631/admin/log/error_log?
```

And we get the flag!!
