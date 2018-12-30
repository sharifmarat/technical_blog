---
Title: Blocked by Hotmail/Outlook
Date: 2017-06-22
Comments: true
Type: "post"
---

Today I discovered that Hotmail/Outlook (live.com) does not want to receive my emails.
Outgoing email bounced with error: 
*host mx1.hotmail.com[65.55.92.168] said: 550 SC-001 (SNT004-MC3F4) Unfortunately, messages from 163.172.218.53 weren't sent*.

<!--more-->

First of all, no IPv6, really?

Anyway, decided to see why my IP could be blocked by Hotmail. 
Checked if it is listed in [public blacklists](https://mxtoolbox.com/blacklists.aspx).
Nope, everything is clean.

Somewhere it was recommended to check IP reputation via [symantec](http://ipremoval.sms.symantec.com/lookup/): 

> The IP address you submitted, 163.172.218.53, does not have a negative reputation 
> and therefore cannot be submitted for investigation.


Time to contact Microsoft. After some digging found URL in people's blogs, not on microsoft's website. Anyway, here is the link:
[Sender Information for Outlook.com Delivery](https://support.microsoft.com/en-us/getsupport?oaspworkflow=start_1.0.0.0&wfname=capsub&productkey=edfsmsbl3&locale=en-us). 

In about 15 minutes received email:

> Reported deliverability problem to Outlook.com SRX.....
>
> Please note that your ticket number is in the subject line of this mail.
>
> 163.172.218.53
>
> Note: Errors are unlikely, however, if an error is indicated, please resubmit the specific IP or IP range.

What does it even mean? Does this email indicate an error and should I resubmit this IP again?
It's been already for 30 minutes and still no new information. Microsoft, what a great way to deal with emails!

**Update**
Quite soon after submitting this post received another email from Microsoft:

> We have completed reviewing the IP(s) you submitted. The following table contains the results of our investigation.
>
> **Conditionally mitigated**
>
> Our investigation has determined that the above IP(s) qualify for conditional mitigation. **These IP(s) have been unblocked, but may be subject to low daily email limits until they have established a good reputation.**
> 
> **Please note that mitigating this issue does not guarantee that your email will be delivered to a user's inbox.**
> 
> Ongoing complaints from users will result in removal of the mitigation.
> 
> Mitigation may take 24 - 48 hours to replicate completely throughout our system.
> 
> If you feel your issue is not yet resolved, please reply to this email and one of our support team members will contact you for further investigation.

Thanks, but really? Why was this IP blocked by default in the first place? And conditionally mitigated?

