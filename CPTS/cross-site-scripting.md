# Cross-Site Scripting

Stored - The pinical it is stored on pag and will be run everytime a user visits

Reflected - processed by server and returned to user not stored

Dom based - Only processed on client side

## Discovery

```shell-session
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
pip install -r requirements.txt
```

```shell-session
python xsstrike.py -u "http://SERVER_IP:PORT/index.php?task=test" 
```

&#x20;[PayloadAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/XSS%20Injection/README.md) [PayloadBox](https://github.com/payloadbox/xss-payload-list) good resources for payloads

## Defacing

This payload can be used to deface a page

```html
<script>document.getElementsByTagName('body')[0].innerHTML = '<center><h1 style="color: white">Cyber Security Training</h1><p style="color: white">by <img src="https://academy.hackthebox.com/images/logo-htb.svg" height="25px" alt="HTB Academy"> </p></center>'</script>
```

## Phishing

Using the defacing method we can craft a malicous page that sends credentials back to us

## Session Hijacking

This was actually pretty fun and the assessment involved a blind XSS injection. Once you found a payload that worked you had to include a script from your machine that sends a cookie to a listening nc port. Cool!

## Skills assesment

This was quite fun and used all parts of the module. You cant use nc for the session because it closes imediatly. php server is better for this,
