---
title: Dutch challenge
author: marat
date: 2016-09-11
template: article.jade
comments: true
---

Tomorrow I am starting another challenge with a friend.
Actually it is happening exactly after I was paying for the lunch 
because I had lost my other challenge to exercise French every day.

<span class="more"></span>

The French challenge I have lost by accident. The challenge was to do 2 duolingo exercises a day.
Unfortunately duo lingo app does not provide such statistics. It just provides how many 
exercises for all languages you did in this day.

In order to make it easy to monitor our progress I have set up a small script in python.
You can read more about deatils [here](/articles/duolingo_challenge/).

To make it simple the script did not actually check that a user did 2 exercise a day.
It checked a magic variable `streak` in a `language` section. At some point I have found
out that it was enough to do only a single exercise in order to get a streak in a single language.
But the challenge agreement was to do 2 exercises. Basically the monitoring tool did not do it job properly.

And that issue actually bit me. One evening I have used the tool to check if I did my French lesson
in the morning. And it showed me that I was fine. But the next day Duolingo app said to me that
I lost my streak. It turns out that I only did a single exercise in the morning and lost the challenge.

From tomorrow we are starting a new challenge to exercise Dutch language. Now I have spent some time
to improve the monitoring tool.
