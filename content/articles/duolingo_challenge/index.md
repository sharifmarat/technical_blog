---
Title: Duolingo challenge
Date: 2016-08-07
Comments: true
Type: "post"
---

Duolingo is a fun way to learn a langugage. To insipre learning even further we introduced a challenge with friends. The idea is simple. A person who loses a streak on a language fails the challenge. But Duolingo keeps track of global streak only. 

<!--more-->

There a few options to keep track of a streak for a certain language:

* Chivlary. A participant honestly keeps track how many times they exercise a language. Easiest option, but no automation.
* Write a script to check a streak per language. Duolingo provides this information via public API. 
* Write a script to check experience for a language every 24 hours. More complicated than the previous option because requries some storage.

API of Duoling is pretty simple: `https://www.duolingo.com/users/<username>`. It returns lots of information about user: global streak, stats per language, achievements.

With a simple script it was trivial to extract streak per language data:

``` Python
#!/usr/bin/env python3
import urllib.request
import json

def getUserDataAsJSON(user):
    with urllib.request.urlopen("https://www.duolingo.com/users/" + user) as url:
        return json.loads(url.read().decode())
    return None

def getLanguage(userData, languageCode):
    languages = userData['languages']
    return next(language for (index, language) in enumerate(userData['languages']) if language["language"] == languageCode)

def getStreak(user, languageCode):
    userData = getUserDataAsJSON(user)
    languageData = getLanguage(userData, languageCode)
    return languageData["streak"]
```

### Issues

For more than 30 days the script did the job. Unfortunately I have encountered a few issues with this approach.

The first issue is the definition of a language streak. For a global streak user must earn specified amount of experience. This amount can be adjusted. But to stay on a language streak minimum experience is enough. In the beginning we agreed to earn at least 20 exp, but with this API 10 exp was enough.

The second issue was much worse. It was encountered when switching time zones. I was travelling from UTC+1 to UTC+2 for holidays. When I opened Duolingo app in a different zone I noticied that I lost both global and local streaks. Possible reason was that I like to walk on the edge and I was doing exercise 20 minutes before midnight. It looks like Duolingo dropped some streak days. Immediately I changed timezone on my phone. It fixed my global streak at least. But the language streak was lost forever.

The plan is to code a flexible script which counts experience earned every 24 hours despite the time zones. And it would be really great if Duolingo added "challenge friends in French" feature into their apps.
