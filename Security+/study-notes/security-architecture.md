# Security Architecture

## Cloud Infrastructures

Security responsibility for cloud server is laid out by cloud security security matrix.

Hybrid cloud needs to be manually configured on each cloud provider. And differnt security monitoring -> data leakige?

Infrastructure as code. Describes infrastrucure for example servers, networks and databases.

## Network Infrastructure Concepts

Isolation - Physical airgap with no way to communicate between switches. VLANs are a way of doing this without dedicated switches, isolation.

Planes - 1) Infrastructure layer - Sending data/ encryption/ forwarding 2) Contol layer - NAT tables/ dynamic routing 3) Application layer - Manage processess/ SSH/ Creds etc

## Other Infrastructure Concepts

SCADA (Supervisory Control and Data Acquisition System) - Multi-Site control all local, very secure

RTOS (Real Time OS)

High availability - Always on with backups incase one fails.

## Infrastructure Considerations

Need to be available. Resilience MTTR (Mean Time To Repair) how quick to bounce back from error.

Elasticity - Scale to meat demand

Risk transference - Cybersecurity insurance

Patch availability - Have regular updates. Embedded systems are hard to update could put a firewall around the device for added security.

## Intrusion Prevention

Security zones - Different zones and configure access to each zone

IPS - Watches network traffic for known vulnerabilities.

Failure modes - Fail open - When system fails data still flows opposed to fail closed

Monotiting modes - Active monitoring this is inline all traffic goes through IPS and if it fails network is down. Passive monitoring data is copied and passed to IPS system so can't block in real time but is fail open.

## Network appliiances

Jump server - A server on the inside of network that can be securely connected to as part of a secure zone. Can then connect to internal proccesses.

Proxies - Data goes through proxy server good for caching, URL filtering and content scanning. A NAT is a network level proxy. Reverse proxy - Internet -> proxy -> webserver.

Load balancer - Used to balance the load over many web servers. SSL/ TCP offload onto LB, caching, content switching.

Sensors and collectors - Manages all data usually on a SIEM

## Port Security

Authenticate - With IEEE 802.1.X and EAP(Extensible Auth Protocol) it's a framework.

## Firewall Types

Types - Pyshyical hardware on network, application level and router level.

UTM - All in one security on level 4.

Next-gen firefall - On level 7 can view all data and make decisions based on firewall configs. Can see application layer

WAF - Web application firewall. Only applies to HTTP/ HTTPS for example sql injection detection and XSS detection.

## States of Data

Data at rest - Saved on storage device can be encrypted and config access

Data in transit - Encrypted TLS or VPN for security

Data in use - When being processed in memory or CPU this is unecrypted because needs to be acted apon

## Protecting Data

Geographic restrictions - Block by location geofenchig

Obfuscation/ hashing/ encryption/ masking/ tokenisation/ segmentation/ permission restriction

## Resiliency&#x20;

Redundancy/ HA (high availabilty) rollover hardware/ Clustering servers/ load balancing/ hot site complete backup for all hardware and data/ Cold site empty site/ COOP if all tech systems fail do it manually

## Power Resiliency

UPS - Uniterupted Power supply short term solution basically a battery
