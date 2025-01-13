# General Security Concepts

### Security controls

* Technical controls - Firewalls, anti-virus
* Managerial controls - Security policies sent to employees
* Operational controls - Awereness programs, security gaurd
* Physyical controls - PINs, badge readers, locks

### The CIA Triad

* Confidentiality - Encryption/ Access controls
* Avialability -System allways available and backups
* Integraty - Detect modification. Hashing, Digital signiture, Non-repudiation

Non-repudiation - Hash the data and compare at endpoint, do verify the sender as well we use a private key that can be decoded with a public key. RSA

### AAA Framework

* Authentication - Login
* Autherisation - Level of acces the user has
* Accounting - Create log of the login request, data size, time etc.

To auth a device our CA (Certificate Authority) creates a cert for an endpoint and can be verified on the server by the CA.

Autherisation done with roles and groups.

### Gap Analysis

Process of mapping where we are to where we would like to be securitywise.

Indentify weaknesses and create a path to the implemention of fixes.

### Zero Trust

Nothing is trusted aka even if you gain access you cant use everything.

Function planes of operations - 1) Data plane actually moving the data, encryption, NAT, sending data 2) Control plane - defines policies and rules, firewall rules, NAT rules, subnet etc.

Applies to anypart of network; cloud, switch etc.

Controlling trust - Adaptive identity, location, IP address and additional fingerprinting. Policy driven access controls sorts all the data given and determines the level of access.

PEP (Policy Enforcment Point) gathers all info about traffic and sends to PDP (Policy Decision Point) to make a descion.

### Deception and Disruption

Honeybots -Honeynets - Honeyfiles.

Alerts can be triggered and everything is logged. To see attack vectors tried.

Honeytokens can be fake API keys that you leak on a cloud servr to see if attackers try to use them.

### Public Key Infrastructure (PKI)

Asymmetric - Public key can encrypt ONLY, Private key decrypt ONLY. Public key can be given out to anyone. Key escrow a service that manages the keys of individuals

Symetric - One key for encryption and decryption. TOP SECRET

Key exchange - Out-of-band thats in person, on the phone, etc. In band can be done by encrypting the key with asymmetric. **Symetric key from asymmetric keys** - Two pairs of differnt private/ public keys can be combined to create a symmetric key without trasnfering any data on the network!

### Encryption Technologies

TPM (Trusted Platfrom Module) is a cryptography hardware component. Key generators, cryptographic functions/ has persistant memory as keys are burned in at manufactoring/ password protected.

HSM (Hardware Security Module) Bassically a TPM for a network as part of a server. Deticated cryptographic hardware component.

Keys are accessed from a key management system.

Secure enclave is a security proccessor it has its own boot ROM, monitors system boots process, generates random nums, real-time memory encryption, AES encryption and more..

### Obfuscation&#x20;

Stegenography

Tokenization - Replace data with placeholder sent by server

Data masking - Hide some of sensitive original data

### Hashing and Digital Signatures

Collision - Different inputs producing same hash. Problem. MD5 has with issue

Salt is added to the hash - each user has a randomly generated salt

Digital Signature = file -> hashed -> hash is ecrypted with private key -> appended to file

### Certificates&#x20;

Issued by CA (Sertificate Authority).

Root of trust - This the 3rd party solution that provides the authority eg CA.

Who it works is -> Create CSR(Certificate Signing Request) this is done by combining your public key and identifying info) -> CA verifies this and then signs it with CA's private key and send back to server.

If we want to revote a cert create a CRT (Certificate Revocation List).

OCSP (Online Certificate Status Protocol). Relying on the CA to provide all reveocations for every SSL handshake if inefficiant. OCSP stapling inbeds cert staus into the SSL/TLS handshake this is digitally signed by the CA.
