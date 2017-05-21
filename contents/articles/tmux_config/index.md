---
title: TMUX config
author: marat
date: 2017-05-21
template: article.jade
comments: true
---

Config of tmux ("terminal multiplexer" if it makes it easier for you...) to allow 
switching between windows using Alt+number:

<span class="more"></span>

``` shell
# start numeration of windows from 1
set -g base-index 1
# hmm... tmux documentation recommends to change pane-base-index as well
setw -g pane-base-index 1

# switch windows with Alt+#
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3
bind-key -n M-4 select-window -t 4
bind-key -n M-5 select-window -t 5
bind-key -n M-6 select-window -t 6
bind-key -n M-7 select-window -t 7
bind-key -n M-8 select-window -t 8
bind-key -n M-9 select-window -t 9
```
