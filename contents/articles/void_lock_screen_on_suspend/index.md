---
title: Closing laptop lid does not lock screen on Void Linux
author: marat
date: 2018-02-10
template: article.jade
comments: true
---

Void Linux is an amazing operating system which reminded me FreeBSD in Linux world. Many parts were built from scratch,
like runit for init scripts, xbps for package management. And they are minimalistic which makes it
even better. Void uses rolling release to delivers fresh packages on regular basis.

<span class="more"></span>

It works quite well on my old MacBook Air 2011. It required a few hacks, especially for TouchPad, though.

But there was one small issue that bothered me for quite some time. When I closed a laptop's lid, Void
went to sleep (by default sleep-to-ram mode). Yet when I opened the lid back, the screen was not locked.

I could wait for a screensaver to lock the screen after 5 minutes of idle, before
closing the lid. Not ideal, but it was usable.

Recently I looked a bit more into this issue. Apparently such events like `lid closed`, `lid opened`,
`power button pressed` are handled by `acpid` daemon. It stands for Advanced Configuration and Power Interface even daemon.
Check `man 8 acpid` for more details.

In Linux, including Void, it is usually hooked to `/etc/acpi/events/*`. The default distribution catches all events:
``` bash
$ cat /etc/acpi/events/anything 
# Pass all events to our one handler script
event=.*
action=/etc/acpi/handler.sh %e
```

These events are handled by `/etc/acpi/handler.sh` in Void Linux. The part to handle laptop's lid:
``` bash
case "$1" in
#...
    button/lid)
        case "$3" in
                close)
                        # suspend-to-ram
                        logger "LID closed, suspending..."
                        zzz
                        ;;
                open) logger "LID opened" ;;
                *) logger "ACPI action undefined (LID): $2";;
        esac
        ;;
esac
```

The close lid event is passed as `handler.sh button/lid LID0 close` to this script. Which triggers
suspend command `zzz`. `zzz` does not give any details about locking the screen, and I guess it
should not.

I use Mate desktop. In Mate you could lock the screen with command `mate-screensaver-command -l`.

It means that with a small modification to `/etc/acpi/handler.sh` I could probably force Mate to lock the screen.
Just add `sudo -u $USER mate-screensaver-command  -l` to this file before `zzz`:
``` bash
case "$1" in
#...
    button/lid)
        case "$3" in
                close)
                        # suspend-to-ram
                        logger "LID closed, suspending..."
+                       sudo -u $USER mate-screensaver-command  -l
                        zzz
                        ;;
                open) logger "LID opened" ;;
                *) logger "ACPI action undefined (LID): $2";;
        esac
        ;;
esac
```

Note that it is required to run this command as an actual user.

It is possible to improve it further by checking `$DESKTOP_SESSION` env variable to determine which
desktop is used.

