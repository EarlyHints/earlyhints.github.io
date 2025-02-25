---
description: >-
  This is an easy box. We manipulate a URL to access a pcap that contains FTP
  credentials we can then use python to priv esc.
---

# Cap

## Nmap

Our nmap scan shows 3 open ports; 21, 22 and 80 nothing else interesting.

## Site

Looking around the site we can see there is a page to download pcaps. If we poke around we realise that enumerating the number in the url allows us to view any data file we want. If we then download the first pcap at "/data/0" and analyise it in wireshark we can find FTP credentials for user nathan.

## SSH + Escalation&#x20;

If we test the same creds on SSH they work!! We are now in and have got the first flag. To get the root flag we need to find processes with elevated privs running "getcap -r /" shows us python can set uids (how silly!!!). Going to GTFO bins and looking around we find this escalation "python3.8 -c 'import os; os.setuid(0); os.system("/bin/bash")' ".&#x20;

WE CRACKED IT!

## Stuff I Learnt

* The getcap command
* GTFObins is a great resource

