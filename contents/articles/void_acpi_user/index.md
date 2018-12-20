---
title: Incorrect user in ACPI script in Void Linux
author: marat
date: 2018-12-20
template: article.jade
comments: true
---

In previous article [Closing laptop lid does not lock screen on Void Linux](articles/void_lock_screen_on_suspend/) I
showed how to lock the screen when closing a laptop lid on Void Linux. It required to know a user under which the
`mate-session` was started. Default ACPI script in Void Linux does not detect correct user.

<span class="more"></span>

The code below attempts to detect a user:
```
PID=$(pgrep dbus-launch)
export USER=$(ps -o user --no-headers $PID)
```

But it fails, because there are two `dbus-launch` processes on my Void Linux:
```
# ps auxf | grep dbus-launch
root       981  Dec16   0:00 dbus-launch --autolaunch 47a2e --binary-syntax --close-stderr
marat     1038  Dec16   0:00 dbus-launch --sh-syntax --exit-with-session
```

With such snapshot of current processes, `/etc/acpi/handler.sh` would find that `PID=981` and `USER=root`. Later running
`sudo -u $USER mate-screensaver-command -l` would not lock the screen, because `USER` is not `marat.

Quick workaround is to update `/etc/acpi/handler.sh` and iterate over all `dbus-lanuch` processes:
```
USER=
PIDS=$(pgrep dbus-launch)
for p in $PIDS; do
    USER=$(ps -o user --no-headers $p)
    if [ "$USER" != "root" ]; then
        # stop at first non-root user
        break
    fi
done

export USER
```
