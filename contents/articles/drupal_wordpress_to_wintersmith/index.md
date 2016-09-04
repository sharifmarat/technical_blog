---
title: Switching from Drupal and Wordpress to Wintersmith
author: marat
date: 2016-03-13
template: article.jade
comments: true
---

I have been using WordPress and Drupal for a while. It worked well, but recently I have decided to switch to
Wintersmith, static site generator.

<span class="more"></span>

### WordPress and Drupal

Wordpress and Drupal are quite popular CMS (content management system). These platforms are easy to install and start to use.
I like that they offer many themes and I always could find an appropriate one for a website. Trivial integration with MySQL,
comments are available from the box. If you need to extend your webiste it is possible with lots of available plugins.

Altough there are many advandages they also come with negative aspects. What I did not like about them?

## Complexity
I have already mentioned that they are easy to use. What I mean by complexity is that they are big. It is very hard
to know everything about these CMS. And the bigger the system the more possible vulnerabilities it has. They constantly
get targeted by automatic bots. And who knows how many 0-day exploits for Wordpress are around?

## Resource usage
This blog is hosted with multiple other sites on a single machine.  Altough there are not so many visitors here I have started
to notice RAM shortages. It was mainly due to MySQL. Wordpress and Drupal use database to store site content and comments.
Recently MySQL service started to crash due to memory shortages. One could say that I should have just upgraded the machine.
But why does the modern computer cannot serve a few small websites? I remeber that 16 MiB of memory was enough to play
so many different computer games.

I have tried to solve memory issue using caching plugins but it did not work very well for me.
I even had to create swap partition on SSD to aviod MySQL crashes.

### Wintersmith, static site generator
I decided to move to a static site generator. It solves the issues I had with Wordpress and Drupal. After short research on
static site generators I have chosen the [Wintersmith](http://wintersmith.io/). 

Wintersmith takes text files (either plain html or Markdown files) and generates static html pages. 
It is very transparent. On the other hand it is also flexible as it supports plugins and templates written in Jade.

There is no more database (you can still add one if you need), no more constant CMS security updates.
I could store the source for a website on git. The Wintersmith supports site preview which is very convinient when
adding site content.

Obviously it comes with downsides:
* Not as simple as Wordpress or Drupal
* You need to regenerate website manually
* No comments support from the box. If you need comments you could extend the website with [Disqus](https://disqus.com/)
* Need to learn a few new things (like Jade templating)

These downsides were not critical for me so I have decided to swith to Wintersmith.

### Installation
Installation is simple. Assuming that you have `npm` packet manager:
``` shell
npm install -g wintersmith
```
`-g` option is to install the package globally rather than locally.

To initialize the new website generated by the Wintersmith:
``` shell
wintersmith new <path_to_site>
```

It creates a framework for your future side. There are some examples and how-to as a starting point.
Wintersmith allows to preview your site:
```
wintersmith preview -p 8080
```
It starts a lightweight web server on port 8080. Open `http://localhost:8080` in your browser.
Once you modify anything the webserver picks changes immediately and you can see them in the browser.

When the website is ready you can generate static content using command `wintersmith build -o build`.
Where `-o` options specifies the path for generated pages. 


### Workflow, git and automatic website regeneration
I have installed Wintersmith locally and on the hosting computer. In addition I have started the git repository
for a website. All development is done locally using `wintersmith preview` feature.

Once I have modified the content and tested it locally I submit changes to the remote repository:
``` shell
git commit
git push

```
On the hosting machine I have created a separate user to update website content.
``` shell
adduser --disabled-login website
```

Get website by clonning git repository:
``` shell
git clone https://git_remote_path <site_local_path>
```

Generate static content:
``` 
cd site_local_path && wintersmith build
```

And tell your web server to server content from `<site_local_path>/build` path.

To automatically pull changes from git and update the website I wrote a script:
``` shell
#!/bin/bash

# path to wintersmith binary, use `which wintersmith` command to locate it
WINTERSMITH="/usr/local/bin/wintersmith"

# function to update the website content
function update_site {
  if [ "$#" -ne 2 ]; then
    echo "Update site function requires 2 arguments"
    return 1
  fi
  SITE_NAME=$1
  SITE_DIR=$2

  echo "Trying to update site $SITE_NAME"

  # Check if pull is needed from the remote repo.
  REV_COUNT=`cd $SITE_DIR && git fetch && git rev-list HEAD...origin/master --count`
  echo "Found $REV_COUNT new revisions"

  if [ $REV_COUNT -eq 0 ]; then
    echo "Nothing to do..."
    return 0
  fi

  # Pull remote changes
  echo "Rebasing changes..."
  cd $SITE_DIR && git rebase origin/master

  # Backup existing build (just in case)
  if [ -d $SITE_DIR/build ]; then
    echo "Making back up of existinb build"
    mkdir -p /home/website/site_backups
    cd $SITE_DIR && tar czf /home/website/site_backups/${SITE_NAME}-`date +%Y-%m-%d.%H.%M.%S`.tar.gz build
  fi

  echo "Building new site..."
  cd $SITE_DIR && $WINTERSMITH build

  return 0
}

update_site "ifnull.org" "path_to_site"
update_site "site2.com" "path_to_site2"
update_site "site3.com" "path_to_site3"
update_site "site4.com" "path_to_site4"
```

And the last step is to add a regular job to run this script:
``` shell
crontab -u website -e
```

It opens the file with tasks of user `website` to run by `cron`. Add the following line:
``` shell
0 *  *  *  *  <path_to_script>
```
to execute script every hour and save the file.

-----

The next step would be to add possiblity to submit articles by email.
