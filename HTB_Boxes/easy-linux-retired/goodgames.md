# GoodGames

# Nmap scan

<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

# Site scan

We can see that the site is running on flask. And a quick google serach shows it is vunerable to RCE. lets look at the site and come back to this.

Gobuster doesnt reveal anything all that interesting. The exploit I mentioned above does not work on this version. I checked the walkthrough file and saw they use burpsuite and sqlmap to gain the admin creds. I don't like the idea of following walkthroughs like a robot so im closing the walkthrough and will struggle alone!!

I saw Ippsec used foxyProxy with burp so I installed both of these.

Testing in the burp reapeter  I find that this payload logs us in "email=admin' OR 1=1#" and it sets a session cookie I copy it over to our browser and see a cog in the top right which I click.

<figure><img src="../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

I can't seem to get passed this login page and injction doesnt work.

Let's try sqlmap. I found this [website ](https://www.comparitech.com/net-admin/sqlmap-cheat-sheet/)that provides a sqlmap cheatsheet. Using this we ar able to find the database main with a table called user. Dumping this table we get the hash for the admin acount.

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

Beacause I don't want to run hashcat I just googled hash lookup and found the password was "superadministrator"

# Site scan 2

<figure><img src="../.gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

We now see this site. Looking around we can't really do anything besides changing our name. So my guess is this is the vector . Googling I learn about SSTI and try it and it works!

I found this [page ](https://kleiber.me/blog/2021/10/31/python-flask-jinja2-ssti-example/)which showed a good obfuscated payload. And it gives us a shell!

Butt we are stuck in what seems to be a docker container. How do we escape??

I got super stuck and had to look at the writeup again.

They use "script /dev/null bash" what is that??? And then they ssh into augustus machine.

So augustus can write files and root in the docket container can add permissions. Let exploit!!

And we get the flag!!
