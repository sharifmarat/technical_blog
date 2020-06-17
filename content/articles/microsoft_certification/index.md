---
Title: Catch of Microsoft Azure Certification
Date: 2020-06-17
Comments: true
Type: "post"
---

Free vouchers for Azure Certification were offered in our company.
Surprisingly for myself I signed up for the exam. But there is a catch.

<!--more-->

This post starts in exactly same way is my previous one: [Infinite redirect in Firefox](/articles/firefox_redirect/):

```
Our company uses Microsoft services for emails, calendars, sharepoints, doing the work...
```

Opinion of developers is barely checked when the company selects a software.
For example Skype for Business was the company's choice as a communicator, despite high percentage of employees having troubles with it on Linux.
These days enterprises switch to Teams. It works on Linux, but feature parity and support for Linux is the worst.

Anyway, recently in my company free certification tracks for Azure were offered. Learning about a new cloud provider could be interesting.
So I signed up for the first exam: Azure Fundamentals. There were two ways to go through the exam: go to a certification center or online.
Who still goes to cetification centers for cloud certification?! Sounds a bit absurd. So, online was chosen.

The Azure Fundamentals has reading and exercise material. Microsoft provided that it will take apprximately 9 hours to go through the learning material.
Briefly checked the material, I thought that an evening before the exam will be enough for preparation.

Fast forward to today, one night before the exam. I successfully went through 70% of leaning material. Decided to take a break and check exactly what
is needed for the exam. Oh, it looks very serious: they require ID, digital photo, a phone near you during an exam so that someone can call you and
check on you. Before the exam they will examine your room. Ok, I guess Microsoft wants to increase value of certificates.

There is also something like "Perform a system test" in the invitation email. Probably something that can be skipped, as video chats work smoothly from
all major systems and browsers. Wait, wait, wait, there is something like "download the software". I did not even want to do "a system test" before, but
now they mention something about "Ensure you have administrative rights on your computer to be able to download the software."

Ok, you got me interested in a system test. Click the link and the website offers "OnVUE-3.22.30.exe" for download. That's strange that they cannot detect
that I am from Linux. After a minute of trying to find download link for Linux I am getting worried that it might not exist. Let me find the requirements
for this online exam software:

```
System requirements

Windows 10 (64-bit) Windows 8.1 (64-bit)
Mac OS 10.13 and above (excluding beta versions)

Windows Vista, Windows XP and Windows 7 are strictly prohibited for exam delivery

All Linux/Unix based Operating Systems are strictly prohibited.
```

Oh wow, "Linux is strictly prohibited" :) For Azure Certification Exam. That's the irony.

The last quick attempt: `wine OnVUE-3.22.30.exe` - does not work. Ok, not worth trying to make it work.

Since the exam cannot be rescheduled or even cancelled less than 24 hours before the start, I wanted to express my frustration and notify the exam people that I won't be able to join. So I contacted the exam center through the online chat:

```
Marat: Hi. I have an Azure exam scheduled for tomorrow.
       Just found funny statement: "All Linux/Unix based
       Operating Systems are strictly prohibited."
       Is this a joke? I though that we were talking about
       Azure clouds in which a lot of Linux services are running.
       Microsoft "surpises" again. I don't care about refund
       as it was a company voucher, but that is just the feedback.
       Thank you.
......: Hi. I would be happy to help you with that.
        There are system requirements decided by the Microsoft.
......: Therefore, if there is any difference with that please
        contact Microsoft directly in this concern.
Marat: I understand that there are reasons :) Anyway, if you can 
       cancel the exam so that no one will be wasting time
       waiting for me to join tomorrow, I guess that's the best to do.
......: I can see that you are scheduled for AZ-900 exam in English
        via Online (Internet Based Test)
Marat: yes, but I guess I cannot dail in from Linux
......: I have checked and the exam can neither be canceled
        nor rescheduled within 24 hours from the scheduled appointment.
Marat: I saw that as well, but I just wanted to notify that
       I won't be able to dial in. If that's fine for you - also fine for me
......: The exam cannot be rescheduled or cancelled
......: Is there anything else I can assist you with today?
Marat: No, thank you
Info: Thank you for contacting Pearson VUE Live Chat. Have a great day!
```

It is even impossible to cancel the exam without no-show.
