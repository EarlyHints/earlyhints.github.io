---
description: How I set up a python app to monitor my home LAN and track websites and usage.
---

# LAN Monitor 1

## Step 1 - Configure router and syslogs

I have a draytek router on my home netwrok and the process for keeping logs is rather simple. Got to System Mainenance > SysLog and configure the settings

<figure><img src=".gitbook/assets/image (4) (1).png" alt=""><figcaption></figcaption></figure>

Because I want this program to be runnign 247 I am forwarding the data to my Dell rack server, it's also pretty convient because I can use IDRAC to connect at any point and monitor on the fly.

Now that we have these settings confgured we download the [Draytek Syslog Utility](https://www.draytek.com/support/resources/others) on our host server. Windows servers have all ports closed by defualt so we need to create a firewall rule to allow inbound traffic on the port.

The last step is to go into the utility and configure the database record.

<figure><img src=".gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

As you can see I'm only saving the User Access data as that's where all the fun stuff is!

## Step 2 - Get data to python

We're using a tool called pyodbc to access and query databases in python. So the first step is to install Microsoft Access to be able to open the ".mdb" file from the syslog utility. The link for that is [here](https://www.microsoft.com/en-us/download/details.aspx?id=54920).

Opening up the database we see the LOG table is what we want.

<figure><img src=".gitbook/assets/image (2) (1) (1).png" alt=""><figcaption></figcaption></figure>

I crafted the following SQL query to get the data from the database for a specific hour of a specific day

```
SELECT msg FROM LOG WHERE RouterT LIKE '%Jan  9%' AND RouterT LIKE '% 22:%';
```

This query mathces the router time and gets all the data for January 9th at 10pm. And it works fine&#x20;

The next day I try this

```
SELECT msg FROM LOG WHERE RouterT LIKE '%Jan  10%' AND RouterT LIKE '% 22:%';
```

And low and behold it returns 0 results. Can you guess why?

I was pulling my hair out and eventually i worked out that this works.

```
SELECT msg FROM LOG WHERE RouterT LIKE '%Jan 10%' AND RouterT LIKE '% 22:%';
```

Spot the diffrence?

On double digit days there is on space between the month and day like "Jan 10" and on single digit days there 2 spaces like "Jan  9"!!!

It took me a long time to work this one out but we now have our precouis data in python!

## Step 3 - Getting hosts and visualising data

Our psuedo code is as follows.

1. Run every hour
2. Get all https request destination ip addresses
3. Do a host lookup and save data to file so we don't need to lookup if it's a known host
4. Store all the data to a file&#x20;
5. Use the file to visulaise the data

My code for the domain lookup is as follows:

```python
import re
import json
from collections import Counter
import pyodbc
from datetime import datetime, timedelta
import calendar
import time
import socket
import warnings

warnings.filterwarnings("ignore")
class logManager:
    def __init__(self):
        with open("domainList.txt", "r") as f:
            self.domains = [i.split(",") for i in f.read().split("\n")[:-1]]
        a = time.time()
        self.startHour = int(a+3600 - a%3600)
        
    def run(self):
        while True:
            while time.time() < self.startHour:
                time.sleep(10)
            print("running")
            self.startHour += 3600
            self.saveData(self.getTCP(self.getData()))
            print("Added data")
    
    def getData(self):
        MDB = './SyslogDB/192.168.1.1/Vigor_v2.1_2025-01-09.mdb'
        DRV = '{Microsoft Access Driver (*.mdb, *.accdb)}'
        con = pyodbc.connect('DRIVER={};DBQ={}'.format(DRV,MDB))
        cur = con.cursor()
        d = datetime.today() - timedelta(hours=1)
        month = calendar.month_abbr[d.month]
        dateString = f"%{month}{" "*(3-len(str(d.day)))}{d.day}%"
        hour = d.hour
        SQL = f"SELECT msg FROM LOG WHERE RouterT LIKE '{dateString}' AND RouterT LIKE '% {hour}:%';" 
        rows = cur.execute(SQL).fetchall()
        rows = [row[0] for row in rows]
        cur.close()
        con.close()
        print(f"Got data {len(rows)} rows")
        return rows
    
    def getTCP(self, log, ports=[443, 8080]):
        ipList = []
        macList = []
        for line in log:
            for port in ports:
                ip = re.findall(f"> (.*):{port} \(TCP\)",line)
                if ip:
                    ipList.append(ip[0])
                    macList.append(re.findall(f"MAC=(.*)\):",line)[0])
                    break
        data = []
        for ip, mac in zip(ipList, macList):
            domain = self.getDomainFromIp(ip)
            if domain != "none":
                data.append({"domain": domain, "mac": mac})
        return data
    
    def getDomainFromIp(self, ip):
        for [storedIp, domain] in self.domains:
            if storedIp == ip:
                return domain
        domain = "none"
        try:
            domain = socket.gethostbyaddr(ip)[0]
            domain = ".".join(domain.split(".")[-2:]) if ".co." not in domain else ".".join(domain.split(".")[-3:])
        except socket.herror:
            pass            
        self.domains.append([ip, domain])
        self.saveDomain()
        return domain
    
    def saveDomain(self):
        with open("domainList.txt", "w+") as f:
            f.write("\n".join([",".join(line) for line in self.domains]))

    def saveData(self, data):
        with open("sysData.json", "r") as f:
            currentData = json.loads(f.read())
        if len(currentData) == 48:
            currentData.pop(0)
        dataDict = {}
        macList = list(set(x["mac"] for x in data))
        for mac in macList:
            domList = []
            for dp in data:
                if dp["mac"] == mac:
                    domList.append(dp["domain"])
            mostVisited = Counter(domList).most_common(3)
            total = len(domList)
            dataDict[mac] = {"mostVisited":mostVisited, "total":total}
            
        with open("sysData.json", "w") as f:
            currentData.append(dataDict)
            f.write(json.dumps(currentData))

l = logManager()
l.run()
```

My code to visulise the data is

```python
import streamlit as st
import json
import pandas as pd
import math

st.set_page_config(layout="wide")
def getAllMacs(data):
    macs = []
    for elem in data:
        macs += list(elem.keys())
    return list(set(macs))
def getFreqData(data, mac):
    freq = []
    for e in data:
        val = 0
        if mac in e.keys():
            val = e[mac]["total"]
        freq.append(val)
    return freq

def getMostViewedData(data, mac):
    freq = {}
    for e in data:
        if mac in e.keys():
            val = e[mac]["mostVisited"]
        else:
            continue
        for site in val:

            if site[0] in list(freq.keys()):
                freq[site[0]] += site[1]
            else:
                freq[site[0]] = site[1]
    freq = "Most viewed sites\n"+"\n".join([f"- {k} - {v}" for k, v in sorted(freq.items(), key=lambda item: item[1])[::-1][:5]])
    return freq
st.title("Syslog Data")
with open("sysData.json", "r") as f:
    data = json.loads(f.read())
    
macs = getAllMacs(data)
rowAmount = math.ceil(len(macs)/3)
columns = [i for i in st.columns(3) for _ in range(rowAmount)]

for num, mac in enumerate(macs):
    column = columns[num]
    tile = column.container(height= 700)
    tile.subheader(mac)
    freqData = getFreqData(data, mac)
    chart_data = pd.DataFrame(freqData)
    tile.bar_chart(chart_data)
    sitesText = getMostViewedData(data, mac)
    tile.markdown(sitesText)
```

## Analysing the data

I have obfuscated the MAC addresses and actual data for security purposes but this is how the data apears.

<figure><img src=".gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

### Findings

1. We can note the main sites visited are all security CMS systems like cloudfront and akamitechnologies. This makes sence because lets say you visit BBC your page may only make a handful of requests to BBC servers but everytime you click or move your mouse a callback will be sent to a captcha service to verify you're a human.
2. In the dummy data above you can't see this but the main network usage was between 6-10pm when most people on my home network were active.
3. There was also data at all times from random IoT devices on the network
