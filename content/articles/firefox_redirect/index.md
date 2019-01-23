---
Title: Infinite redirect in Firefox
Date: 2019-01-23
Comments: true
Type: "post"
---

Recently Firefox started to throw an error on some sites that a page was not redirecting properly.
On the internet, people gave recommendations to clear the browser cache and cookies, but it didn't help me.
It turned out that the issue was quite different, but simple.

<!--more-->

Our company uses Microsoft services for emails, calendars, sharepoints, doing the work, fixing bugs and so on.
At some point I lost the ability to check work emails from one laptop. This laptop was in no way special.
Office 365 actually worked from Chromium, but not from Firefox. I tried to debug this issue a little. I found multiple
reports that Microsoft Office 365 login got stuck in a loop. Almost all recommendations were limited to re-installing the browswer,
clearing cookies and cached data. Didn't work for me. Office 365 relocated to Chromium, no big deal.
And Microsoft was to be blamed again.

Some time passed and I found another website which didn't work on Firefox: https://digid.nl/inloggen.
Firefox didn't enter the infinite loop, but gave an error: "The page isn’t redirecting properly". It reminded me of the issue
with Office 365.

I tried to clear everything from Firefox, tried different versions. Nothing seem to help and the infinite redirect was consistent.
With network debugging I found that digid.nl provided two cookies in the first response:
```
Set-Cookie: _session_id=xxx;Secure; domain=.digid.nl; path=/; expires=Wed, 23 Jan 2019 21:47:39 -0000; HttpOnly
Set-Cookie: _persist=yyy;domain=.digid.nl; HttpOnly;secure; path=/
```

But I saw a single coookie in following requests to the server:
```
Cookie: _persist=yyy
```

After that the server went to the previous step and sent 2 cookies to Firefox. Firefox consistently requested to proceed further
with a single request cookie. That continued for a while and stopped with Firefox giving up:
"The page isn’t redirecting properly".

It was easy to find that the expiration time of `session_id` cookie was past my current system time. Time difference explained why Firefox immediately removed
this cookie (but did not explain Chromium behavior). My time was 1 hour off and `session_id` expiration time was set for 15 minutes.
I had mess with system time and timezones on my machine. Fixing the time fixed login to Office 365 and digid.nl websites.

Check your system time if clearing cookies in Firefox does not help you with infinite redirect loops.

