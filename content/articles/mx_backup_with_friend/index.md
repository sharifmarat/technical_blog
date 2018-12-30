---
Title: MX backup with a friend
Date: 2016-12-23
Comments: true
Type: "post"
---

You just finished setting up your MX server and everything works fine. 
And now you are wondering whether you need a secondary MX server for backups.
Some would say that these days you actually don't need a secondary MX server,
because MTAs (mail transfer agent) queue mail if MX server is down.
In addition a secondary MX server might be abused by spammers.
But just for fun, let's assume you want to have a backup MX server.
And you are lucky enough to have a friend who also runs an MX server which he is willing
to configure as your backup server.

<!--more-->

Let's say your mail server is `mail.me.com` and your friend's `mail.friend.com` on
which you both run postfix as MTA.

### DNS MX records
First make sure that DNS records are correct. You both need to set up DNS records to have
secondary MX records point to each other:
``` shell
mail.me.com   A        1.1.1.1
me.com        MX   0   mail.me.com
me.com        MX   10  mail.friend.com
```
``` shell
mail.friend.com   A        2.2.2.2
friend.com        MX   0   mail.friend.com
friend.com        MX   10  mail.me.com
```

### Postfix relay and transport
Postfix allows to set up mail relaying. It can be used to relay friend's emails if a request
comes to `mail.me.com` server which would happen if `mail.friend.com` is down. In that case
Postfix queues a message and retries to relay it later to `mail.friend.com`.

Just update postfix to allow mail relay to `friend.com` with a proper transport (no MX lookup, see below).
Add following lines to `/path/to/postfix/main.cf`:
``` shell
relay_domains = friend.com
transport_maps = hash:/path/to/postfix/transport
```

**Make sure** that `friend.com` is not listed in `virtual_maps` and `mydestination`.

You also need to overwrite default relay transport in  `/path/to/postfix/transport` to avoid DNS loops 
(when primary MX server is not available and mail is relayed to a secondary MX which is the same host):
``` shell
friend.com smtp:[mail.friend.com]
```
Brackets [] disable MX DNS lookup hence the mail for `friend.com` is relayed to A record of `mail.friend.com`.

### Postfix queue
In this set up if `mail.friend.com` is down then a secondary MX server, which is `mail.me.com`, would be used.
Postfix on `mailme.com` would try to relay mail, but since the destination host is down it would queue it for later delivery.

By default, postfix keeps such mail for 5 days, but it can be increased using option `bounce_queue_lifetime = 10d`.
