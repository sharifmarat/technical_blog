---
title: Transmission status from Raspberry Pi 3
author: marat
date: 2016-12-04
template: article.jade
comments: true
---

I have a transmission client running on Raspberry Pi 3. But what I also wanted is to have 
a simple way to check the status of this client with a simple glance.
Raspberry Pi 3 has multiple LEDs on-board.
Luckily, one of them can be easily controlled from a user space.

<span class="more"></span>


### Raspberry Pi on-board LEDs
**PWR** - indicates power to device. Hardwired which makes it impossible to control.

**FDX**, **LNK**, **10M** - indicate LAN activity. In theory it is possible to control them.
It might be necessary to recompile the kernel to get access to them.

**OK** - indicates SD card activity. It is wired to GPIO16 which makes it the easiest to control.

### Playing with **OK** LED

``` shell
$ cd /sys/class/leds/led0/
$ ls
brightness  device  max_brightness  subsystem  trigger    uevent
```

There are different triggers which control this LED:
``` shell
$ cat trigger
none [mmc0] mmc1 timer oneshot heartbeat backlight gpio cpu0 cpu1 cpu2 cpu3 default-on input rfkill0
```

By default the trigger is set to mmc0 (mmc stands for MultiMediaCard) and it flashes based on
SD card activity.

To switch this LED into manual mode:
``` shell
$ echo none >trigger
```

And to turn it off/on:
``` shell
$ echo 0 >brightness #off
$ echo 1 >brightness #on
```

It is also possible to make this LED flash:
``` shell
$ modprobe ledtrig_timer   # or use 'modprobe ledtrig_heartbeat' for different pattern
$ echo timer >trigger      # or use 'echo heartbeat >trigger' for different pattern
```

### Tranmsission status

Transmission has a remote-control utility to control tranmission daemon.
For example, to list all current entries:
``` shell
$ transmission-remote -n user:password -l
```

Connected transmission status with LED status in a script:
``` shell
#!/bin/bash

# check if everything is finished
transmission-remote -n user:password -l | grep '%' grep -q -v 100%

if [[ $? != 0 ]]; then
  # all finished, turning off LED
  echo none >/sys/class/leds/led0/trigger
  echo 0 >/sys/class/leds/led0/brightness
else
  # in process, keep flashing LED
  echo timer >/sys/class/leds/led0/trigger
fi
```

And add it to cron to update status every minute:
``` shell
* * * * * /path/to/script.sh
```

