---
Title: Dockerized email
Date: 2022-02-03
Comments: true
Type: "post"
---

I've been running my personal email server for almost 6 years.
The initial setup was on "bare metal". Afterwards only little maintenance time was needed.
Recently I decided to reduce number of servers and moved to another provider.
To avoid migrating "bare metal" setup, I dockerized it. It is still not very easy to use compared to existing solutions, but works for my scale.

<!--more-->

The dockerized image source is on [GitHub](https://github.com/sharifmarat/docker-email) and supports:
- `postfix` with virtual users based on file setup
- `dovecot` for imap, auth and `sieve` for filtering
- encrypted mail directories by default for all users with `mail-crypt-plugin`
- `spamassassin` for spam filtering
- DKIM optionally

## Runit to supervise multiple docker processes

When I was dockerizing all email related service, I was not aware of the best docker practices to make a single image with multiple services,
but run them in separate containers. At that time I decided to make a single container to supervise multiple processes in a single docker container.
`runit` init system was used. Most of the services was easy to add, but postfix required a special attention due to isolation. The final list of services:
```
# cat /service/postfix/run 
#!/bin/bash
/usr/lib/postfix/configure-instance.sh postfix
exec /usr/lib/postfix/sbin/master

# cat /service/cron/run
#!/bin/bash
exec cron -f

# cat /service/dovecot/run
#!/bin/bash
exec dovecot -F

# cat /service/opendkim/run
#!/bin/bash
exec opendkim -x /etc/opendkim.conf -f

# cat /service/rsyslog/run
#!/bin/bash
exec rsyslogd -n

# cat /service/spamassassin/run
#!/bin/bash
exec spamd --max-children 5
```

In the future I am planning to split these service into multiple containers according to the best docker practices.

## Virtual users, domains and aliases

A few files have to be mounted for proper setup:
- `virtual_domains` which contains list of domains for virtual transport
- `virtual_boxes` describes accounts for the virtual transport
- `virtual_aliases` adds additional aliases

### Encrypted mailboxes

All mailboxes are encrypted by default with dovecot `mail-crypt` plugin. `/etc/dovecot/users` is used to configure user passwords.
To generate a new password you can use
```
doveadm pw -s SHA512-CRYPT -p "<PASSWORD>"
```

**NOTE:** If user's password is lost, mailbox cannot be decrypted anymore

To change user's password it is not enough to change it in `/etc/dovecot/users`. Prevoius email won't be possible to decrypt anymore.
To set new password for the private key run:
```
doveadm mailbox cryptokey password -u "$user" -n "$password_new1" -o "$password_old"
```

## Certificates

To support renewable certificates it is better to mount the whole folder and provide `CERT_LOCATION` and `CERT_KEY_LOCATION`.
If you mount files directly, inode might change during certificate renewal and postfix/dovecot won't be able to use new cert until container is restarted.

## DKIM

DKIM setup is not trivial and requires manual setup of private and public keys for all your virtual domains. 
Later I plan to simplify it.

## With docker

To run this container with docker:
```
docker run -d \
    -e MAILNAME=example.com \
    -e DKIM_ENABLED=true \
    -e CERT_LOCATION=/etc/letsencrypt/live/mx.example.com/fullchain.pem \
    -e CERT_KEY_LOCATION=/etc/letsencrypt/live/mx.example.com/privkey.pem \
    -p 25:25 \
    -p 143:143 \
    -p 587:587 \
    -v /etc/letsencrypt/live/example.com:/etc/letsencrypt/live/mx.example.com:ro \
    -v /etc/letsencrypt/live/example.com:/etc/letsencrypt/archive/mx.example.com:ro \
    -v /path/to/dkim:/etc/opendkim \
    -v /path/to/mail:/mail \
    -v /path/to/users:/etc/dovecot/users \
    -v /path/to/virtual_domains:/etc/postfix/virtual_domains \
    -v /path/to/virtual_accounts:/etc/postfix/virtual_boxes \
    -v /path/to/virtual_aliases:/etc/postfix/virtual_aliases \
    postfix-dovecot
```

## With docker-compose

To run this container with docker-compose:

```
  myemail:
    container_name: myemail
    hostname: myemail
    image: postfix-dovecot
    volumes:
      - /etc/letsencrypt/live/mx.example.com:/etc/letsencrypt/live/mx.example.com:ro
      - /etc/letsencrypt/archive/mx.example.com:/etc/letsencrypt/archive/mx.example.com:ro
      - /path/to/dkim:/etc/opendkim
      - /path/to/mail:/mail
      - /path/to/users:/etc/dovecot/users
      - /path/to/virtual_domains:/etc/postfix/virtual_domains
      - /path/to/virtual_accounts:/etc/postfix/virtual_boxes
      - /path/to/virtual_aliases:/etc/postfix/virtual_aliases
    environment:
      - MAILNAME=example.com
      - DKIM_ENABLED=true
      - CERT_LOCATION=/etc/letsencrypt/live/mx.example.com/fullchain.pem
      - CERT_KEY_LOCATION=/etc/letsencrypt/live/mx.example.com/privkey.pem
    ports:
      - 25:25
      - 143:143
      - 587:587
    networks:
      my_net:
        aliases:
          - mx.example.com
    restart: unless-stopped
```
