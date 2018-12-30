---
Title: Setting up Raspberry Pi 3
Date: 2016-03-07
comments: true
Type: "post"
---

Recently Raspberry Pi Foundation released new version of thier product: Raspberry Pi 3.
It has 64-bit quad-core ARM CPU and integerated wireless LAN. It is great thing to play with and I got it for myself.

<!--more-->

### Installation

Together with Raspberry Pi I have bought the standard case, power adapter and micro SD card with "NOOBS".
Assembling is trivial, you just put Raspberry Pi inside the case, insert micro SD card and plug HDMI cable into it.
Do not forget about keyboard and mouse (I am not sure if you can follow installation process without mouse).
Once powered the Raspberry Pi boots and installation starts. Depending on SD card you can choose operating system to install.
In my case it was single one: Rasbian which is Debian based OS. Next, next, next and wait for a few minutes. Done.

### Wireless mouse issues

During installation I have already noticed that my wireless mouse did not work properly.
It was terribly lagging. I could still move it and click, but even clicking a few Next buttons was not trivial.
My hope was that after installation it would get better. But no, the issue was still present.
I briefly tried to find way to fix it but nothing worked. And since the plan was to connect to Raspberry pi via ssh
I decided not to spend a few nights figuring out what was wrong with wireless mouse.


### WIFI issues

Once installed you probably want to connect it to the Internet. Raspberry Pi 3 comes with integrated WIFI card.
I connected it to my WIFI router and started Internet surfing (with terrible mouse experience).
It worked a little bit until the WIFI connection dropped out. Interesting. The distance to router was quite small, around 4 meters without any obstacles.
When the connection came back I have checked pings and it was terrible. The WIFI connection kept dropping every few minutes.
After googling a little bit I have found people claiming that it might be related to power management.  Let's check if it helps:

``` shell
sudo iwconfig wlan0 power off
```

During the next 10 minutes connection never dropped out and pings looked much better.
Ok, now let's make it permanent, otherwise the power management would be back after the next reboot.
It can be disabled in `/etc/network/interfaces` by adding post-up `iwconfig wlan0 power off || true` for all wireless interfaces:
``` shell
allow-hotplug wlan0
iface wlan0 inet manual
    post-up iwconfig wlan0 power off || true
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet manual
    post-up iwconfig wlan1 power off || true
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

### Autossh service
The next step is to setup autossh service. I want to connect to Raspberry pi via ssh from outside my local network.
The easiest choice for me is reverse ssh tunnel. ssh daemon is already present in Raspbian.
Installation of autossh is trivial: `sudo apt-get install autossh`.

And the last step is to make sure that autossh starts reverse tunnel on system boot.
And here I realize upstart is missing from Raspbian. I was very surprised by that fact. Does it still use plain sysv?
Ok, should not be a problem: sudo apt-get install upstart. It gives some warnings, ignore them. Upstart is ready.
Then I created upstart service `/etc/init/autossh.conf` to start autossh on boot. Verifying that it works:
``` shell
sudo service autossh start
ps aux | grep ssh
```

Great, but on the next reboot autossh did not start. It was not even mentioned anywhere in `/var/log/syslog`.
I took around 2 hours before I realized that Raspbian uses systemd. systemd, really? That was fast.

Not all people are in favor of switching to systemd. It's maintly due to attidue of systemd developers.
As example you can read their responses in this  [email discussions](http://lkml.iu.edu/hypermail/linux/kernel/1404.0/01327.html) about kernel failure due to systemd.
Go through these emails and also check links to the bugtracker with responses from systemd developers.
They show very nice attitude when discussing kernel failure to boot on systems without cgroups (caused by systemd):
> Lennart Poettering: To make this work we'd need a patch, as nobody of us tests this.

Ok, back to autossh issue. Can I remove systemd and use upstart. It looks like it would be very difficult to do.
So let's make systemd service for autossh. Add new file `/etc/systemd/system/autossh.service`:
```
[Unit]
Description=autossh tunnel
After=network-target nss-lookup.target

[Service]
Environment="AUTOSSH_GATETIME=0"  # avoids stopping after first ssh failure
ExecStart=/usr/bin/autossh -M 0 -N -R 70000:127.0.0.1:22 -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -o "StrictHostKeyChecking=no" -o "BatchMode=yes" -i private_key pi@remotecomputer

[Install]
WantedBy=multi-user.target
```
Enough of systemd scripts for today.

