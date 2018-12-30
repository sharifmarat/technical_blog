---
Title: Getting admin access for Comtrend VI-3223u router
date: 2016-03-02
comments: true
Type: "post"
---

I have got **Comtrend VI-3223u** router from my ISP. Unfortunaly they do not give you full access to this router.
Recently I have discovered that with limited access you cannot do even simple things like configuring static IP address 
in DHCP or setting up parental control. If you are interested how to get full access for this router then this article is for you.

<!--more-->

Before we start I assume that you have access to your router via http (the most common location is **http://192.168.1.1**) 
and you can login with user with limited rights. Let's assume that login name is "**user**" (it is in my case).

### Investigating open ports

If you login with **user** via http then you can find that there is limit set of settings you can change.
Let's check other means to access the router:

``` bash
$ nmap 192.168.1.1
Starting Nmap 5.51 ( http://nmap.org ) at 2016-03-02 22:40 CET
Nmap scan report for Comtrend.
Home (192.168.1.1) Host is up (0.0037s latency).
Not shown: 993 closed ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
23/tcp   open  telnet
80/tcp   open  http
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
5431/tcp open  park-agent
```

As you can see the router has a few interesting ports to check: ftp, ssh, telnet.
Unfortunately I could not get anything useful neither from telnet nor ssh:

``` shell
$ telnet 192.168.1.1
Trying 192.168.1.1...
Connected to comtrend.home.
Escape character is '^]'.
Connection closed by foreign host.

$ ssh user@192.168.1.1
ssh_exchange_identification: read: Connection reset by peer
```

I have not tried ftp. Maybe it has some holes?


### Looking for hidden html content

Before I started to fiddle around with router I checked the Internet if there were any available exploits for this router.
I could not find anything. The only thing I found was some hidden html pages.
Hidden in the sense that there are no direct links to them from router web pages. These pages proved to be useful.


**http://192.168.1.1/password.html** allows to change user's password. Unfortunately only if you know the current password.
But it gave insights into different accounts on the router:
```
Access Control -- Passwords
Access to your broadband router is controlled through three user accounts: ADMIN_ACCOUNT_1, ADMIN_ACCOUNT_2, and user.
The user name "ADMIN_ACCOUNT_1" has unrestricted access to change and view configuration of your Broadband Router.
The user name "ADMIN_ACCOUNT_2" is used to allow an ISP technician to access your Broadband Router for maintenance and to run diagnostics.
The user name "user" can access the Broadband Router, view configuration settings and statistics, as well as, update the router's software. 
```

Ok, so now we know that there are two more accounts (**admin** and **support**) with higher access rights than **user**.
I tried many stanadard passwords like (admin, 12345, root) but it did not work.

The next interesting hidden html page is **http://192.168.1.1/backupsettings.conf** It collects all router settings
(even those that you cannot see or modify using **user** account) and gives it to you as an xml file.
It contains all information to setup internet connection. You can use them to setup own router 
instead of **Comtrend VI-3223u** provided by ISP. I almost decided to go this way.
But then I noticed that this config file contains my **user** password (base64 encoded) to access the router:
``` xml
<X_BROADCOM_COM_LoginCfg>
  <UserPassword>c29tZXBhc3N3b3JkaGVyZQo=</UserPassword>
</X_BROADCOM_COM_LoginCfg> 
```

It would have been convinient if it had AdminPassword and SupportPassword as well.
What would happen if I add admin and support passwords to this config file and upload it back to the router.
Luckily there is another hidden webage to upload config file to router **http://192.168.1.1/updatesettings.html**.
Let's modify config file and try to update router settings:
``` xml
<X_BROADCOM_COM_LoginCfg>
  <AdminPassword>c29tZXBhc3N3b3JkaGVyZQo=</AdminPassword>
  <SupportPassword>c29tZXBhc3N3b3JkaGVyZQo=</SupportPassword>
  <UserPassword>c29tZXBhc3N3b3JkaGVyZQo=</UserPassword>
</X_BROADCOM_COM_LoginCfg>
```

<div class="alert warning">
  <span class="icon warning"></span>
  **hybrid-cloudblog** pointed that it did not work with new firmware.
  The following workaround might help:
  `<AdminPassword notification="2">c29tZXBhc3N3b3JkaGVyZQo=</AdminPassword>`
  as he describes it [here](http://www.hybrid-cloudblog.com/get-admin-acces-tele2-3223u-adsl-modem/).
</div>

For simplicity I used the same password as **user**'s password for **admin** and **support** accounts.
Go to **http://192.168.1.1/updatesettings.html** and update router setting using modified config file.
Wait for it to come back.

Once the router comes back try login with **ADMIN_ACCOUNT_1**(you get admin account name from **http://192.168.1.1/password.html**)
user name and user's password. **WOW, it works!** I have got full right access to my router.
Finally I could setup static DHCP addresses and parental control.

But can we go further? Who would not like shell access to his router?

### Getting shell access

Using your admin account in the web client of the router navigate to **Management > Access Control > Services**.
Put ssh and telnet into **LAN+WAN** access mode. Save settings and let's try telnet again:
``` shell
$ telnet 192.168.1.1
Trying 192.168.1.1...

Connected to comtrend.home.
Escape character is '^]'.
Broadband Router
Login: ADMIN_ACCOUNT_1
Password: <known users password here>
> help
?
help
reboot
psp
ps
dns
cat
... many more other commands 
```

Wow, now telnet works. But unfortunately it does not have useful commands like **ls**, only **cat**.
But even using **cat** we can get some interesting info:
``` shell
> cat /etc/passwd
ADMIN_ACCOUNT_1:hashed_password:0:0:Administrator:/:/bin/sh
ADMIN_ACCOUNT_2:hashed_password:0:0:Technical Support:/:/bin/sh
user:hashed_password:0:0:Normal User:/:/bin/sh
nobody:hashed_password:0:0:nobody for ftp:/:/bin/sh
```

This is not really useful since we already know the admin's password and even know how to change it.
Let's see if we can execute something outside of provided commands by telnet. Check if semicolon can help us:
``` shell
> echo ; ls
Warning: operator ; is not supported!
```

Bummer... But what about pipe?
``` shell
> echo | ls
bin dev lib mnt proc sys usr webs
data etc linuxrc opt sbin tmp var
```

**It works!** You can run any availalbe shell command (ls, cp, rm, mkdir,... check bin directory to see more) using "pipe" trick.
Now you are only limited by your imagination. To make your investigations easier you can connect usb driveto the router
and cp everything to this drive: `echo | ls cp bin etc lib /mnt/usb1_1/`.

