# Lan Monitor 2

For this project I will be using my dell rack server. The reasons for this are; 1) It is easier to cinnect as it is already in my server room 2) It has better hardware so it will be able to process the network data faster than a rasberry pi.

## LAN mirroring

We first need to mirror all network traffic and send it to our rack server. Luckly this is fairly easy

1 - We need to plug our rack server into a router port I have chosen port 4

2 - We need to mirror to this port bellow if the configuration for this.

<figure><img src=".gitbook/assets/image (1) (1).png" alt=""><figcaption></figcaption></figure>

## Intercepting traffic

My dell server is windows so lets check the interfaces we have available.

<figure><img src=".gitbook/assets/image (2) (1).png" alt=""><figcaption></figcaption></figure>

I know I plugged the ethernet for port mirroring into NIC1 so thats the interface we need. Lets make note of it's IP.

Now we need to install winPcap and winDump. This is straight forward.

With these installed we can now run this command to save all data to a file.

```
windump -1 3 -w capture.pcap
```

## Python for credential sniffing

I created the following python script to sniff for common passsword patterns on HTTP FTP and Telnet

```python
import pyshark
import requests
import re
import time
import subprocess
import threading
import os

SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/xxxxx"

patterns = {
    "HTTP Basic Auth": r"Authorization: Basic ([a-zA-Z0-9+/=]+)", 
    "HTTP Form Auth": r"username=(\S+)&password=(\S+)",
    "HTTP Cookie Auth": r"Cookie: (.*?=(.*?))",
    "HTTP Digest Auth": r"Authorization: Digest (.*)",
    
    "FTP Credentials": r"USER\s+(.+?)\r\nPASS\s+(.+?)\r\n",
    "FTP Cleartext Login": r"^USER\s+([^\r\n]+)\r\nPASS\s+([^\r\n]+)\r\n",


    "Telnet Credentials": r"^USER (.+?)\nPASS (.+?)\n",
    "Telnet Cleartext Login": r"Password: (.+?)\n",
    "Telnet Negotiation": r"^((?:\xFF\xFD.*?)+)\xFF\xFB\x01",
}

def send_slack_alert(message):
    payload = {"text": message}
    requests.post(SLACK_WEBHOOK_URL, json=payload)
    print(message)

def analyze_pcap():
    pcaps = [file for file in os.listdir() if "capture_" in file]
    for pcap in pcaps:
        if int(pcap.split("_")[1][:-5]) +60 > time.time():
            continue
        capture = pyshark.FileCapture(pcap, display_filter="http or ftp or telnet", use_json=True, keep_packets=False)
        for packet in capture:
            if hasattr(packet, 'http'):
                if hasattr(packet.http, 'authorization'):
                    match = re.search(patterns["HTTP Basic Auth"], packet.http.authorization)
                    if match:
                        send_slack_alert(f"HTTP Basic Auth credentials found: {match.group(0)}")

                if hasattr(packet.http, 'file_data') and packet.http.file_data:
                    try:
                        data = bytes.fromhex(packet.http.file_data.replace(":", "")).decode("utf-8")
                    except UnicodeDecodeError:
                        continue
                    print(data)
                    match = re.search(patterns["HTTP Form Auth"], data)
                    if match:
                        send_slack_alert(f"HTTP Form-based Auth credentials found: USER={match.group(1)} PASS={match.group(2)}")

                if hasattr(packet.http, 'cookie') and packet.http.cookie:
                    match = re.search(patterns["HTTP Cookie Auth"], packet.http.cookie)
                    if match:
                        send_slack_alert(f"HTTP Cookie Auth (Session Token) found: {match.group(1)}={match.group(2)}")
                        
                if hasattr(packet.http, 'authorization') and 'Digest' in packet.http.authorization:
                    match = re.search(patterns["HTTP Digest Auth"], packet.http.authorization)
                    if match:
                        send_slack_alert(f"HTTP Digest Auth detected: {match.group(0)}")

            if hasattr(packet, 'ftp'):
                if hasattr(packet.ftp, 'request') and 'USER' in packet.ftp.request and 'PASS' in packet.ftp.request:
                    match = re.search(patterns["FTP Cleartext Login"], packet.ftp.request)
                    if match:
                        send_slack_alert(f"FTP Cleartext credentials found: USER={match.group(1)} PASS={match.group(2)}")

                if hasattr(packet.ftp, 'request') and 'AUTH' in packet.ftp.request:
                    match = re.search(patterns["FTP AUTH TLS/SSL"], packet.ftp.request)
                    if match:
                        send_slack_alert(f"FTP AUTH TLS/SSL negotiation detected: {match.group(1)}")
                        
            if hasattr(packet, 'telnet'):
                if hasattr(packet.telnet, 'data'):
                    match = re.search(patterns["Telnet Cleartext Login"], "".join(packet.telnet.data))
                    if match:
                        send_slack_alert(f"Telnet Cleartext credentials found: USER={match.group(1)} PASS={match.group(2)}")
                    match = re.search(patterns["Telnet Negotiation"], "".join(packet.telnet.data))
                    if match:
                        send_slack_alert(f"Telnet negotiation (potential authentication) detected: {match.group(1)}")
                    if type(packet.telnet.data) == str:
                        send_slack_alert(f"Telnet data found: {packet.telnet.data}")                  

            capture.close()
            os.remove(pcap)
    
def runWindump():
    while True:
        pcap = f"capture_{int(time.time())}.pcap"
        try:
            subprocess.call(f'windump -i 3 -w "{pcap}" -s 0', timeout=60)
        except subprocess.TimeoutExpired:
            pass
        
threading.Thread(target=runWindump).start()
while True:
    time.sleep(10)
    analyze_pcap()
```

### Code explanation

1. We create patterns to identify certain request types
2. We create threaded function that run winDump every 60 seconds and creates a new pcap file
3. We run our main function that loads these pcap and searches for any matching patterns
4. Send this data to our slack account


## Showcase

<figure><img src=".gitbook/assets/image (3) (1).png" alt=""><figcaption></figcaption></figure>

We can see we get notified when I (on a different device) try to login usind a http request.

## Findings

For obvious resons I will not show any real results but the interesting finding were

1. A lot of telnet passwords were found. These were from scrappers trying to access my routers telnet login. Telnet is not encypted so any MitM attack could read these.
2. No real http credentails were found. People just don't do that in a real world setting
3. I manually looked and found a lot of http proxy authentications with base64 encoded username and passwords. This is from a seperate project that I am running but it was interesting to see proxy authentication is done over HTTP not HTTPs. This prompted me to change my proxy passowrds to not resemble any of my normal passswords
4. It would be not be possible to try SSL stripping with this approach but perhaps it could be a later project...
