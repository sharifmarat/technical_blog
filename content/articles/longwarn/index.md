---
Title: Improved way to run cron
Date: 2021-12-30
Comments: true
Type: "post"
---

Systemd timers is an interesting alternative, but I still prefer `crontab` over it to run periodic jobs on my servers.
To make it a bit more reliable I just chain a few commands like `cronic`, `longwarn` and `flock`.

<!--more-->

My usual crontab looks something like this:
```shell
MAILTO=scripts

14  *  *  *  * cronic longwarn  600 flock -n /run/lock/my-script.lock /run/some/script.sh
```

`MAILTO` is an address to which I receive an email if something fails on a scheduled job. I also have a hook to send a message via telegram bot in certain cases.

`cronic` helps to avoid unwanted emails from cron. It only sends a message if a script returned non-zero result code or had any error output.
That allows to have scripts with standard output in `crontab`. If something goes wrong, you will see full output (and not something with a quiet option).

`longwarn` changes a return code from success to error if a script takes too long to run.
For example, if a script above takes more than 10 minutes, I will receive a message with a warning.

And `flock -n <lock_file>` fails a script if a previous job is still running.
Sometimes is it not desired to have two instances of the same script running in parallel, because they could disrupt each other.
By default I do not allow two parallel executions on the same job.
