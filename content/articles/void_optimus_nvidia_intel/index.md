---
Title: Dual Intel and Nvidia graphics on Void Linux
date: 2019-01-11
comments: true
Type: "post"
---

Nvidia Optimus technology allows seamlessly switch between two graphics cards on a laptop.
An Intel integrated card is used to safe battery life when performance is not needed.
A discrete Nvidia card is turned on for certain applications, like games, mining.
It was a big tricky to setup dual graphics on Void Linux. A few hints below could help you to take advantage
of this technology on Linux.

<!--more-->

It is well describe on [wiki.voidlinux.eu](wiki.voidlinux.eu) how to setup either Nvidia or Intel graphics card on Void Linux.
The issue comes when you try to install OpenGL libraries for both Nvidia and Intel graphics. It does not work, because
these libraries conflict with each other. It is possible to upgrade from mesa `libGL` to `libGL` from Nvidia,
but not in another direction.  If you already installed OpenGL libraries for Nvidia, you have to remove them first (including
all dependencies) before installing mesa OpenGL libraries for Intel graphics.

I ended up re-installing Nvidia and mesa OpenGL libraries for at least 5 times when trying to setup Nvidia Optimus on my laptop,
HP Envy 13. That's why I describe hints below which could help you to achieve the same. I say hints, because
I don't remember exact steps and I don't want to remove everything again :)

1.Start with mesa OpenGL libraries for integrated Intel graphics card. Make sure that you install it correctly and it works. I mainly
used `glmark2` to verify my video drivers. With integrated Intel graphics output should look something like that:

```
$ glmark2
=======================================================
    glmark2 2017.07
=======================================================
    OpenGL Information
    GL_VENDOR:     Intel Open Source Technology Center
    GL_RENDERER:   Mesa DRI Intel(R) UHD Graphics 620 (Kabylake GT2) 
    GL_VERSION:    3.0 Mesa 18.3.1
=======================================================
[build] use-vbo=false: FPS: 758 FrameTime: 1.319 ms
[build] use-vbo=true: FPS: 780 FrameTime: 1.282 ms
=======================================================
                                  glmark2 Score: 769 
=======================================================
```

2.Per Jan 12 2019: do not install Nvidia drivers from default Void Linux repository.
If you try to install `Bumblebee` (for Optimus) with Nvidia drivers and libraries, it would remove mesa libraries and Nvidia becomes your
default graphics without an option to switch back to Intel integrated graphics.

3.Install Nvidia kernel module only (without Nvidia libraries). Download Nvidia libraries manually.
You could do it either from official website [https://www.nvidia.com/Download/index.aspx?lang=en-us](Nvidia libraries) or from Void Linux repository.

4.Extract Nvidia libraries into a separate folder.
I have used the blob from Nvidia website with the following parameters:

```
$ ./nvidia-installer --x-prefix=/opt  --x-module-path=/opt/lib/xorg/modules \
      --x-library-path=/opt/lib --x-sysconfig-path=/opt/share/X11 --opengl-prefix=/opt \
      --compat32-prefix=/opt --compat32-libdir=lib32 --utility-prefix=/opt --documentation-prefix=/opt \
      --application-profile-path=/opt/share/nvidia
```

It installs Nvidia libraries into `/opt` directory for x86_64 and x64 architectures.
I had to play with `--no-opengl-files` parameters in order not to overwrite system (mesa) OpenGL libraries.

5.By that step you should have working mesa OpenGL, Nvidia kernel module and Nvidia libraries in `/opt` directory.

6.Install `bbswitch` kernel module to enable/disable discrete graphics.

7.Clone [https://github.com/Witko/nvidia-xrun](nvidia-xrun) script. It starts a separate X session with Nvidia graphics enabled.

8.Create file `/etc/X11/nvidia-xorg.conf`

```
Section "Files"
  ModulePath "/opt/lib32"
  ModulePath "/opt/lib"
  ModulePath "/opt/lib32/vdpau"
  ModulePath "/opt/lib/vdpau"
  ModulePath "/opt/lib/xorg/modules"
  ModulePath "/opt/lib/xorg/modules/drivers"
  ModulePath "/opt/lib/xorg/modules/extensions"
  ModulePath "/opt/lib/tls"
  ModulePath "/usr/lib/xorg/modules"
EndSection

Section "Module"
    Load "modesetting"
EndSection

Section "Device"
    Identifier     "nvidia"
    Driver         "nvidia"
    # Use lspci to find proper BusID
    BusID          "PCI:1:0:0"
    Option "AllowEmptyInitialConfiguration"
EndSection
``` 

9.Copy `nvidia-xrun/nvidia-xinitrc` to `/etc/X11/xinit/nvidia-xinitrc`.

10.Specify which window manager or a program to start with Nvidia enabled. For that create file `~/.nvidia-xinitrc`

```
if [ $# -gt 0 ]; then
  $*
else
  xrandr --setprovideroutputsource modesetting NVIDIA-0
  xrandr --auto
  xrandr --dpi 96
  # use your own window manager
  exec mate-session
fi
```

11.Modify `nvidia-xrun` (probably can be done in `/etc/X11/xinit/nvidia-xinitrc` as well) to add `/opt/lib` (or `/opt/lib32` for x86)
to dynamic loader when starting new Nvidia X session:

```
diff --git a/nvidia-xrun b/nvidia-xrun
old mode 100644
new mode 100755
index 39b1b94..6153811
--- a/nvidia-xrun
+++ b/nvidia-xrun
@@ -69,6 +69,9 @@ EXECL="/etc/X11/xinit/nvidia-xinitrc $EXECL"
 
 COMMAND="xinit $EXECL -- $NEWDISP vt$LVT -nolisten tcp -br -config nvidia-xorg.conf -configdir nvidia-xorg.conf.d"
 
+echo "adding /opt/lib to ldconfig"
+execute "sudo ldconfig /opt/lib"
+
 # --------- TURNING ON GPU -----------
 echo 'Waking up nvidia GPU'
 if ! [ -f /proc/acpi/bbswitch ] 
@@ -117,3 +120,6 @@ then
 else
   echo "Bbswitch kernel module not loaded."
 fi
+
+echo "removing /opt/lib to ldconfig"
+execute "sudo ldconfig"
```

12.Switch to `tty1` (with Ctrl+Alt+F1) and run `nvidia-xrun`. Verify with `glmark2` that Nvidia graphics is used:

```
$ glmark2
=======================================================
    glmark2 2017.07
=======================================================
    OpenGL Information
    GL_VENDOR:     NVIDIA Corporation
    GL_RENDERER:   GeForce MX150/PCIe/SSE2
    GL_VERSION:    4.6.0 NVIDIA 410.78
=======================================================
[build] use-vbo=false: FPS: 1668 FrameTime: 0.600 ms
=======================================================
                                  glmark2 Score: 1668 
=======================================================
```

13.To see whether Nvidia graphics cards is turned on or turned off you could run `cat /proc/acpi/bbswitch`.
In daily life when Nvidia is not used you should see something similar to

```
0000:01:00.0 OFF
```

You could also blacklist Nvidia kernel modules by default.

As far as I remember I had to manually remove `/opt/lib/xorg/modules/libwfb.so` library.
