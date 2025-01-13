---
description: How I set up a python app to monitor my home LAN and track websites and usage.
---

# LAN Monitor

## Step 1 - Configure router and syslogs

I have a draytek router on my home netwrok and the process for keeping logs is rather simple. Got to System Mainenance > SysLog and configure the settings

<figure><img src=".gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

Because I want this program to be runnign 247 I am forwarding the data to my Dell rack server, it's also pretty convient because I can use IDRAC to connect at any point and monitor on the fly.

Now that we have these settings confgured we download the [Draytek Syslog Utility](https://www.draytek.com/support/resources/others) on our host server. And we need to configure some firewall settings to allow data on port 514.

The last step is to go into the utility and configure the database record.

<figure><img src=".gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

As you can see I'm only saving the User Access data as that's where all the fun stuff is!

## Step 2 - Get data to python

We're using a tool called pyodbc to access and query databases in python. So the first step is to install Microsoft Access to be able to open the ".mdb" file from the syslog utility. The link for that is [here](https://www.microsoft.com/en-us/download/details.aspx?id=54920).

Opening up the database we see the LOG table is what we want.

<figure><img src=".gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

I crafted the following SQL query to get the data from the database for a specific hour of a specific day

```
SELECT msg FROM LOG WHERE RouterT LIKE '%Jan  9%' AND RouterT LIKE '% 22:%';
```

This query mathces the router time and get all data for January 9th and 10pm. And it works fine&#x20;

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

On double digit days there is on space between the month and day like "Jan 10" and on single digit days there 2 like "Jan  9"!!!

It took me a whileeee to work this one out but we now have our precouis data in python!

## Step 3 - Getting hosts and visualising data

