---
title: Fix for touchpad in Void Linux on MacBook Air
author: marat
date: 2018-12-12
template: article.jade
comments: true
---

Fixing MacBook Air's touchpad (versions 2011-2012) in Void Linux.

<span class="more"></span>

Add kernel module `bcm5974` to kernel's initramfs:
```
sudo dracut --force --add-drivers bcm5974
```

Update dracut configuration files to include this module when building initramfs:
``` shell
$ sudo sh -c 'cat <<EOF >/etc/dracut.conf.d/touchpad.conf
add_drivers+="bcm5974"
EOF'
```
