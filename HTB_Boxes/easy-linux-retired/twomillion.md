# TwoMillion

# Nmap

<figure><img src="../.gitbook/assets/image (20).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

We find an invite page that wants us to hack in!&#x20;

We find a js file [http://2million.htb/js/inviteapi.min.js](http://2million.htb/js/inviteapi.min.js) here is the deobfuscated code

```
function verifyInviteCode(code) {
    var formData = {
        "code": code
    };
    $.ajax({
        type: "POST",
        dataType: "json",
        data: formData,
        url: '/api/v1/invite/verify',
        success: function(response) {
            console.log(response)
        },
        error: function(response) {
            console.log(response)
        }
    })
}

function makeInviteCode() {
    $.ajax({
        type: "POST",
        dataType: "json",
        url: '/api/v1/invite/how/to/generate',
        success: function(response) {
            console.log(response)
        },
        error: function(response) {
            console.log(response)
        }
    })
}
```

So lets make a posrt request to that endpoint. We get back a base64 encoded string and reveersing it we get: BYE38-JMTR7-N84QB-CDZ9B which works as a invite code.

We make a user and get in we see an access page with an interesting api endpoint...

# API Enumeration

/api/v1 -> Give us a bunch on intereting endpoints

We want admin access to let stry the /admin/settings/update endpoint. Luckily the errors tell us exactly what we need to add to get a valid request. And we upgrade our account to admin!!

Testing the /vpn/generate enpoint we find we can do code injection. So let's get a reverse shell by encoding a shell with base64. And we get in!

Once in we find admin creds for ssh

# Priv esc

Let's loot at the mysql server first we find some hashed passwords... Let come back to this if linpeas doesnt find anything.

Linpease finds an interesting mail file at /var/mail/admin

Looking at it they mention OverlayFS / FUSE lets look into that we find a exploit on [github](https://github.com/puckiestyle/CVE-2023-0386).

And we get root!!
