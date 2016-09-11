---
title: Dutch challenge
author: marat
date: 2016-09-11
template: article.jade
comments: true
---

Tomorrow I am starting another challenge with a friend to study Dutch.
Actually it is happening exactly after I invited friends and paid for their luch today,
because I had lost my previous challenge which was to exercise French every day.

<span class="more"></span>

The French challenge was lost by accident. The challenge was to do 2 duolingo exercises a day.
Unfortunately duo lingo app does not provide statistics to track how many exercise for a particular
language was done. It just shows how many days you were on a streak and streak is based on all languages.

In order to make it easy to monitor our progress I set up a small script in python.
You can read about it [here](/articles/duolingo_challenge/).

To make it simple the script did not actually check that a user did 2 exercise a day.
It checked a magic variable `streak` in a `language` section. It looks like duoling also has a language streak
concept in their API, but it is not public.
At some point I have found out that it was enough to do only a single exercise in order to get a language streak.
But our challenge was to to 2 French exercises. Basically the monitoring tool did not do it job properly.

And that bit me. One evening I used the tool to check if I did my French lesson
in the morning. And it showed me that I was fine. But the next day the Duolingo app said to me that
I lost my streak. Apparently I only did a single exercise in the morning which was enough for the monitoring tool,
but not enough to stay in the challenge.

From tomorrow we are starting a new challenge to study Dutch. One part of the challenge is to do `N` 
exercies a day where `N` can vary based on agreement. Based on the fact that the last time I lost almost only because
of bad tooling (and also because of bad memory), I improved it to keep track of earned experience,
which represents number of exercise 1-to-1 (I hope that it does).

The improved script remembers amount of experience and checks that a user earns at least 20 experience a day
to keep the challenge going. I doubt that it represents 2 exercises exactly, because I can see that 
experience is not divisible by `10` (I have experience of `1102` for some language).
