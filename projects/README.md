---
layout: default
---
# My Projects

Here, you'll find a collection of my cybersecurity and Python development projects, each designed to enhance network security, monitor activity, and identify vulnerabilities. From network monitoring tools to hands-on security implementations, these projects showcase my technical skills and passion for cybersecurity.

<style>
table {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    border-collapse: collapse;
  }
  
  tbody {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
  }
  
  tr {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 250px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    text-align: center;
  }
  
  tr:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
  }
  
  tr a {
    text-decoration: none;
    color: inherit;
    display: block;
    width: 100%;
    height: 100%;
  }
  
  tr td:nth-child(3) a {
    display: block;
    width: 100%;
  }
  
  tr td:nth-child(3) a img {
    width: 100%;
    height: 150px;
    object-fit: cover;
  }
  
  td {
    padding: 10px;
  }
  
  tr td:nth-child(1) {
    font-size: 18px;
    font-weight: bold;
  }
  
  tr td:nth-child(2) {
    font-size: 14px;
    color: #555;
    padding-bottom: 15px;
  }
</style>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("table tbody tr").forEach(row => {
        let imgCell = row.querySelector("td:nth-child(3) a");
        if (imgCell) {
            let imgSrc = imgCell.getAttribute("href");
            let img = document.createElement("img");
            img.src = imgSrc;
            img.alt = "Project Image";
            img.style.width = "100%";
            img.style.height = "150px";
            img.style.objectFit = "cover";
            imgCell.replaceWith(img);
        }
    });
});
</script>

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Lan project 1</strong></td><td>A project were I configure my router to log all https request and run domain lookups to map network usage.</td><td><a href=".gitbook/assets/cyber-network-protection-future-technology-background-free-vector.jpg">cyber-network-protection-future-technology-background-free-vector.jpg</a></td><td><a href="lan-monitor-1.md">lan-monitor-1.md</a></td></tr><tr><td><strong>Lan project 2</strong></td><td>A more advanced network monitoring tool where I mirror all network data to check for unecrypted authentication.</td><td><a href=".gitbook/assets/cyber1.jpg">cyber1.jpg</a></td><td><a href="lan-monitor-2.md">lan-monitor-2.md</a></td></tr><tr><td><strong>Honey pot</strong></td><td>A project were I go through the steps to set up a honey pot on my LAN and find some interesting scrapers crawling my network</td><td><a href=".gitbook/assets/Honeypot-_BlogCover_1024x475.png">Honeypot-_BlogCover_1024x475.png</a></td><td><a href="honey-pot.md">honey-pot.md</a></td></tr><tr><td><strong>Internal audit</strong></td><td>A project where I go through the steps of auditing my home network and implenting hardening methods.</td><td><a href=".gitbook/assets/1000_F_508110367_b8wvsGj3fyZmEwGmmLOgPmpxGhh3Naad.jpg">1000_F_508110367_b8wvsGj3fyZmEwGmmLOgPmpxGhh3Naad.jpg</a></td><td></td></tr></tbody></table>
