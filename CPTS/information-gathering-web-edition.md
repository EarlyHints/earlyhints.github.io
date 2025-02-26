# Information Gathering - Web Edition

WHOIS looks -> SImple enough

DNS lookup -> Dig look at [this](footprinting.md#dns)

Subdomain enumeration with ffuf

Can look up certificates to find subdomains with [crt.sh](https://crt.sh)

## Fingerprinting

wafw00f -> Can detect WAF on sites

nikto -> Versitile tool for web scanning

## Crawlers

scrapy -> Very good for custom spider

reconspider -> get emails and other helpful links from site

## Dorking

&#x20;[Google Hacking Database](https://www.exploit-db.com/google-hacking-database)

<figure><img src=".gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

Wayback machine mentioned

finalrecon -> automate recon process

## Assesment

This was pretty simple all we did was enumerate subdomains with ffuf (twice).

I then needed to get all the text off the website so I tried reconspider and scrapy but didnt have much luck so instead I used cewl.

PAWNDDD
