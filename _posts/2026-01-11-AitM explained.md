---
title: AiTM explained + demo
date: 2026-01-11 21:00:00
categories: Blogging
tags: [aitm, mitm, phising, saas, bec, proxy]
description: Demonstrating an AiTM attack and examining the logs
---


## What is Adversary in the Middle (AiTM)?
 Adversary in the Middle is the name given to a class of Man in the Middle attacks typically used to steal SaaS credentials. An attacker intercepts the communication between a user and a legitimate website; this allows them to steal sensitive information like passwords and session cookies even if the user has enabled multifactor authentication. Given the emergence of Phishing as a Service (PhaaS) products the setup needed to conduct this type of attack has become much easier and it remains an incredibly effect method in Business Email Compromise (BEC) campaigns.
## How does AiTM work?
An attacker positions their proxy server between the user and the website they are trying to access.

I have created a demo of this behavior on this site: [aitm-phishing-research-demo.com](https://aitm-phishing-research-demo.com)
![Phishing Sign In Page](/assets/img/AitM/demo.png)
_Fig 1: Phishing Sign In Page_
> Do NOT use real details if you try out this site!
{: .prompt-danger }

When a user navigates to this site the backend server forwards the HTTP request to login.microsoftonline.com. The server receives a response from Microsoft which is edited to replace all login.microsoftonline.com links with links to the malicious domain; the cookie "domain"
field is also updated to the malicious domain. This edited response is then sent to the user.

This method allows for a legitimately looking login to take place, **INCLUDING** any MFA the user has on their account. It all gets proxied from Microsoft to the user and vice versa.

![Graphic illustrating AiTM](/assets/img/AitM/graphic.png)
_Fig 2: Graphic illustrating AiTM_

The server acts as a middleman, able to view all the traffic between the user and Microsoft in cleartext. This includes the user's email address, password, OTP and sessions cookies. As far as Microsoft knows they are communicating directly to a real user and as far as the user knows they are communicating with Microsoft.
Note: This demo uses o365 as an example but this method of attack is possible universally across all domains.

## What happens next?
After a user has signed and performed MFA the stolen session cookies are sent to the attacker.
These cookies include:

| Cookie Name        | Type   | Comments                                                                                                                                                        |
| ------------------ | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ESTSAUTH           | Common | Contains user's session information to facilitate SSO. Transient.                                                                                               |
| ESTSAUTHPERSISTENT | Common | Contains user's session information to facilitate SSO. Persistent.                                                                                              |
| ESTSAUTHLIGHT      | Common | Contains Session GUID Information. Lite session state cookie used exclusively by client-side JavaScript in order to facilitate OIDC sign-out. Security feature. |

An attacker can then navigate to Microsoft and add these cookies to there session. They can do this with a variety of free cookie editor extensions available on the Chrome/Firefox Web Store.

The attacker is now logged in the the victim's account with an MFA validated cookie and has the ability to wreck havoc!

## Indicators of Compromise (IoCs)

Due to HTTPS being used is is hard to identify this kind of attack purely with network traffic alone. On the wire we would see an encrypted TLS connection. The server IP address and hostname would be visible and we could also derive a JA3S fingerprint, these could hint towards a malicious attack but without further investigation it is speculative.

What is really needed to confirm a malicious account takeover is SaaS logs.
To demonstrate the logs you would expect to see in a BEC I used the above phishing site to login to a victim o365 account, I immediately received the stolen cookies in a dedicated Slack channel, I then used these cookies to login to OfficeHome as the victim user.

Lets see the logs!

![SaaS log timeline](/assets/img/AiTM/logs.png)
_Fig 3: SaaS log timeline_

- First there is a login using the IP 162.159.113[.]89, the IP belongs to the Cloudflare ASN. This log was generated when the server (which in this case I had hosted on Cloudflare) proxied the victims authentication request to Microsoft and received the session cookies.
- Several minutes later the attack uses the captured cookies to login to Office365. The IP address seen is 209.127.202[.]146 which is a VPN registered to Cogent Communication LLC.
You'll notice that the victims IP address is not seen anywhere in these logs that is because at no point did the victims IP actually sign in. After the victim signs in to the fake phishing site they are directed to OfficeHome, in this case the victim was not previously signed in so they got directed back to the real Microsoft login page. If the victim had previously logged in there would be a sign in log but their session cookies and Session ID would remain the same as it had previously been.

Other interesting things to note is that the Session ID is consistent across all the malicious activity but the device info and user agent are not necessarily. The first login observed (using the Cloudflare IP) has the user agent and device info that is typical for the victim, due to the fact  that this information was proxied directly from the user to Microsoft. However, the subsequent logins could have different user agents and device info, this could fingerprint the attacker's device but unfortunately this telemetry is easy forged.

In a legitimate case of BEC you would typically see 2 Session IDs from different IPs, one legitimate one from the account owner and one being used by the attacker. These 2 sessions would be performing action simultaneously which would serve as a major IoC.  