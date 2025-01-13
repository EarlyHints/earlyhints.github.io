# Threats, Vulnerabilities, and Mitigations

### Common Threat Vectors

Message-based vectors - Phising with email or SMS, to steal creds, or download malware or pay for unrendered services.

Image-based vectord - SVG javascript inbedded

File-based - PDF could contain code, software hidden in ZIP, macro in office products

Voice call vectors - Vishing - voice phising

Removable device vectors - Malicous software on USB, or rubber ducky acting as a keyboard to key commands.

Unsupported systems - Can be attacked as this system isnt recieving new security patchs. good vector

Unsecured network vectors - Wireless, Wired, Bluetooth can all be attacked.

Open service ports - Misconfig or non updated software can be attacked

Defuat creds - No need to explain

Supply-chain - If 3rd party is hacked your network can be accessed

### Phishing&#x20;

Typosquatting - Purchase domain similiar to real domain.

VIshing - Caller ID spoofing and pretexting to trick end user. By impersinating other people.

### Other attack vectors

* Impersination - Indentify fraud by impersination bank teller to get SSN. So never volunterr information.
* Water hole attack - Attacker will try gain access to third party service you use. They add malware to this service to try gain access to your servers. Need good firewall and IPS.
* Misinformation - Diseminate fake infomation in order to further a narrative. Brand impersonation make a site with good SEO to rank in google searches and get users to click BOOM malware.
* Memory injections - Malware hides in memory. Can inject into a process that has high priveledges and is hard to detect. DLL (Dynamic Link Library) injection.
* Buffer overflow - To inject code into memory. Devlopers need to do bounds checks.
* Race condition - When two proccesses happen simultaniously. Time-of-check to time-to-use (TOCTOU) attack. You check a value and perform a manipulation of this value, if this manipulation is slow the value can be changed after the initial check and it will then be overwritten by the proccess.
* Malicous updates - Updating from an insecure source. Having a backup of a server is a good idea incase updates go wrong. Updates from trusted sources could also be hacked if the companies dev enviroment was hacked.
* OS vulns - Update every month&#x20;
* SQL Injection - Can be used in browser by breaking out of query. This is very bad obviously as entire bd can be traversed.
* Cross-site scripting (XSS) - Inbed javascript in site. This link can be sent to a user to return the the SessID and cookie info. Persistant XSS posts a post with malicous code and anyone who loads this page will be infected!&#x20;
* Hardware vulns - With IoT we need to make sure the firmware on these devices are secure. had to do as only the manufacturer can provide these patches. EOL (End of Life) notice no more security updates after date  EOSL (End Of Service Life).
* Virtulaization - Can by used throughout system. Priv esc, command injection + info gathering. VM escape to move between VMs attack. Resource reuse in the case hardware overlap data can be written to other VMs.
* Cloud vulns - DoS attack to worry about, directory traversal, unpatached. Out of bounds write - write to other areas, SQL, XSS.
* Misconfiguration - This can be aws buckets, unsecured admin accounts, insecure protocls (telnet, FTP, SMTP, HTTP), default settings password MIRAI botnet, firewall misconfig.
* Mobile device - Install MDM(Mobile Device Manager) on employee phones.  Jailbreaking/ rooting bypassses this. Sideloading install app from untrusted source.
* Zero-days - New vuln no patches yet.

### Malware types

* Ransomeware - Encrypts your drive untill you pay money. OS works fine but no access to file. So use backups that you can use.
* Virus - Repoduces itself over the network. Can be detected by signatures anti-virus uss this to detect. Filesless only operates in memory no files written, makes it harder to detect.
* Worm - Self replicate without user interaction. IPS/IDS can stop this worm. Will try infect everything on a network
* Bloatware - Random junk programs added by manufacturer can be suseptible to malware
* Logic bomb - Waits for a condition to trigger the malware. eg login, date/time.
* Rootkit - Modifies core system files as part of kernal. Anti-Virus cant detect, secure boot within bios prevents this.

### Attack vectors

* Physical attack - Exmaples of this are; lockpicking, breaking a window, RFID cloning, turn of cooling system/ electricity.
* DoS - We can do this accidentially for example pluging 2 switchs into each other twice. Or a water link or power cute etc. DDOS distributed. Amplified DDOS for example query DNS this returns a lot of data that can overwhelm server.
* DNS attack - DNS poisoning on local host file to forward user to fake website. DNS spoofing, changing DNS addresses on DNS server. Domain hijacking hack into domain registration to gain access to domain.
* Wireless attack - De-auth attacks works on older unencrypted AUTH packets. RF (Radio Frequency) jamming so cant access the network, needs to be from closeby. FOX HUNT!!
* On-path - Also known as man in the middle. ARP poisoning pretends to be router ip and sends its own MAC. Browser attack, adds proxy to user account to incerpect unencrypted sensitive data.
* Replay attack - Intercept and replay the request with interceptd data. E.g. hashes, cookies(sesh id). All this can be prevented with HTTP and encryption.
* Application attack - Injection, buffer overflow, replay attack, priv esc, directory traversal.
* Cross-site request forgery (CSRF) - this works by causing the browser to make requests without your knowledge. E.g. inbed an \<img> with a source link that is a get endpoint. Can be provented with CSRF token.
* Cryptographic attacks - Collisions where two different input produce same hash. Downgrade attack, SSL stripping to tell user there is only HTTP for the webserver
* Password attacks - Spraying attack using most common passes online , brute force to crack hash

## Detection and prevention

IOC - Indicators of compromise; uptick in network activity, changes to certain files or changes of DNS data. Concurrent session usage if user is logged in at two seperate locations simultanouesly. Blocked content like securty update. Impossible logins locations.

Segmentation - Zero trust, with ACL (Access Control List) grouping catagories to restrict access to different resourced based on certain rules. Allow/Deny lists for application verified with application hash or cert.

Mitigation - Patching, encrypting files, monitoring logs (firewall/ IPS/ email/ access/ db), least privilege users only have nessicary priveleges very few priveledged accounts, decommisioning destroy all data on drive at EOL.

Hardening - Updating, password requirements, EDR (Endpoint detection and response) monitors behaviour of users and machine learning and process monitoring, host-based firewall, close unused ports, remove redundant software.
