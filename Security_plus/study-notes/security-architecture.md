# Security Architecture

### Cloud Infrastructures

Security responsibility for cloud server is laid out by cloud security security matrix.

Hybrid cloud needs to be manually configured on each cloud provider. And differnt security monitoring -> data leakige?

Infrastructure as code. Describes infrastrucure for example servers, networks and databases.

### Network Infrastructure Concepts

Isolation - Physical airgap with no way to communicate between switches. VLANs are a way of doing this without dedicated switches, isolation.&#x20;

Planes - 1) Infrastructure layer - Sending data/ encryption/ forwarding 2) Contol layer - NAT tables/ dynamic routing 3) Application layer - Manage processess/ SSH/ Creds etc

### Other Infrastructure Concepts

SCADA (Supervisory Control and Data Acquisition System) - Multi-Site control all local, very secure

RTOS (Real Time OS)

High availability - Always on with backups incase one fails.

### Infrastructure Considerations

Need to be available. Resilience MTTR (Mean Time To Repair) how quick to bounce back from error.

Elasticity - Scale to meat demand

Risk transference - Cybersecurity insurance

Patch availability - Have regular updates. Embedded systems are hard to update could put a firewall around the device for added security.

### Secure Infrastructures

