# Footprinting

## Host based enumeration

### FTP

Ftp is typically initiated on port 21 and data is sent on port 20.

Passive mode is when the server tells the client which port is available for data transmission and the client the initiates the connection. To get passed firewall rules.

TFTP - Is trivial is on udp and has less functionality.

If configured to allow anonymous connections we can authenticate with anonymous: anonymous

wget -m --no-passive ftp://ETC can be used to download all files

Useful hint -> If the ftp is encrypted with SSL/TLS can use openssl to intercept the cert and extract a hostname and email

### SMB

Is a file an service manager. Can provide parts of the file system as shares access rights are defined by ACLs and are entirely indedependant of the actual file structure. Typicaly on ports 137, 138 and 139.

Samba is an implementaion of SMB that uses CIFS (Common Internet File System) protocols. It sends data exclusively on TCP port 445.

Use smbclient to connect to smb. smbclient -N -L lists all shares. Can also do "!" in front of a bash command to run it as local.

rpcclient - Is a tool for enumerating SMB shares to find usernames/ shares/ groups

This can be automates with SMBmap or enum4linux-ng (this one provides more info).

### NFS

Network file system -> Basically a file system accessable to be mounted by client

showmount -e -> Used to show mount points

sudo mount -t nfs \<IP>:/ ./\<OUT\_DIR>/ -o nolock

sudo umount ./\<OUT\_DIR> -> to unmount

### DNS

There is 4 levels of a domain - TLD (Top Level Domain), Second level domain, sub-domains, hosts.

<figure><img src=".gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

Can use the dig command to search DNS records dig ANY returns all available data.

Zone transfer -> dig axfr \<DOMAIN> -> dig axfr \<SUBDOMAIN>.\<DOMAIN>

Can obviously used ffuf to brute force subdomains as well. Remeber the HOST header!

### SMTP

Is often combind with IMAP or POP3 protocolos for added deatures. Usually rus on port 25 or 587. Once the user is authenticated and SSL/TLS has been done switch ports to encrypted channel.

SMTP can be spoofed beacuse users arent authenticated so if you manage a SMTP relay you can spam on masse and spoofyour sender email. ESMTP is used to mitigate this problem and it uses TLS to encrypt the entire process including authentication.

<figure><img src=".gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

Can use telnet/nc to send these commands to the SMTP server. Can use a web proxy on the SMTP server using the CONNECT command

Often SMTP servers will be configured to auth all ips known as an open relay We can then spoof emails can test for this with nmap --script smtp-open-relay

### &#x20;fe/ POP3

Internet Message Access Protocol/ Post Office Protocol -> These allow the access of emails IMAP has more feayures like folder/ multiple amilboxes and preselection of emails. on port 143. By default this is unecrypted but many use TLS to encrypt the service.

<figure><img src=".gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

curl -k 'imaps://\<IP>' --user \<USER>:\<PASS> -> This connects us to IMAP

openssl s\_client -connect \<IP>:\<pop3s/imaps> -> This connects us with ssl encryption

A little goggling will get you through the exact IMAP/ POP3 commands to use

### SNMP

Simple Network Management Protocol - used to monitor devices on a network and each device has a unique address MID (Management Information Base) this is made  up of the OID (Object Identifier) and a unique address and name.

SNMPv1 - No in built auth or encryptio

SNMPv2 - SNMPv1 but with more features also no auth on encryption

SNMPv3 - Auth and encryption

Footprinting

onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp.txt \<IP> -> brute force community strings

snmpwalk -v2c -c \<OID> \<IP> -> Query OID process

braa \<OID>@\<IP>:.1.3.6.\* -> brute force names

### MySQL

Can be enumerated with nmap --script mysql\*

mysql -u \<USER> -p \<PASS> -h \<IP> -> used to connect to database\


<figure><img src=".gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

### MSSQL

Microsoft SQL

python3 mssqlclient.py Administrator@10.129.201.248 -windows-auth

### Oracle TNS

Oracle Transparent Network Substrate -> A protocle that facilitates communication between applicatiosn and oracle databases over a network. Used by big companies with complex dbs. It has in built encryption SSL/TLS.

Oracle dbs have defualt passwords that can be googled and tried.

<mark style="color:red;">Oracle Database Attacking Tool (ODAT)</mark> is used to pen test TNS. Can also upload files!! Can get RCE

sqlplus \<USER>/\<PASS>@\<IP>/XE as sysdba -> connect to db

select name, password from sys.user$;

### IPMI

Intelligent Platform Management Interface -> Hardware based host managment system used for monitoring. Used before BIOS or when host is powered down. Before RUN!

\--script ipmi-version used to get version.

iDrac is an example of an IPMI!!

Can use metasploit auxiliary/scanner/ipmi/ipmi\_dumphashes to get hashes. And crack in hashcat

## Remote Management Protocols

### Linux

SSH can be auditted with ssh\_audit (dont this is actually useful nmap is good with the bacis stuff and we wont be reversing encryption)

Rsync guide here [https://book.hacktricks.wiki/en/network-services-pentesting/873-pentesting-rsync.html](https://book.hacktricks.wiki/en/network-services-pentesting/873-pentesting-rsync.html)

R commands can be found on ports 512-514 can can be abused often. Can google this as needed

### Windows

RDP - rdp-sec-check can audit RDP and xfreerdp is used to connect to RDP

WinRM uses TCP ports 5985 (HTTP) and 5986 (HTTPS) can use evil-winrm to connect and we will get a PS session

WMI - Is an admin managment tool can be connected to with wmiexec which is an impacket script



## Skills Assessment

### Easy

<figure><img src=".gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

We know the ssh login already so lets log in. We go to /home/flag and get the flag.&#x20;

Really was easy!!!

### Medium

<figure><img src=".gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

We mount the nfs but we can't open anything...

sudo find mountOut/ -exec cat {} ; This command comes to the rescue and we can read all the files in the share!!

Looking at the output we get the username and passed for alex's SMTP. alex: lol123!mD

Connecting to the SMTP share we find admin credentials!!

Lets try connect to the rdp at 3389 with these creds and it doesnt work But trying again with alex's credentials it does!

Now all we do is open the database and search for our credentials and we get the flag!



### Hard

TCP Scan&#x20;

<figure><img src=".gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

UDP Scan

We find an SNMP server lets use onesixtyone to brute force is. We get the community string of "backup"

Doing a snmpwalk we find credentials tom:NMds732Js2761 -> Lets try this against the imap server and we get in!! Looking around we find an SSH key and we can use it to log in as tom on ssh!!

I looked aroud our mail dirs and found nothing so I took a look at /etc/passwd and found a mysql lets connect. We can use the same password as before

We can see a table called users and in it is our flag. PAWNDEDDD
