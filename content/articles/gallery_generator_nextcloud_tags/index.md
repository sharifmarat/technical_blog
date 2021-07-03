---
Title: Generate gallery from Nextcloud tagged images
Date: 2021-07-03
Comments: true
Type: "post"
---

I could not find a way to share or publish tagged Nextcloud images. This seems like a useful feature
in which you can share all images of a person with them. There are a few feature requests on Nextcloud GitHub,
but Nextcloud 21 still does not implement it. I wrote a small shell script to make it possible.

<!--more-->

There are some requirements before you can re-use this approach.
You should be comfortable with Linux.
The script only works for MySQL installation. I tested it with Nextcloud 21. If a table schema is different, the script must be adapted.

The result can be seen [here](/gallery/public/).

The script to generate such a gallery from tagged images is on GitHub: https://github.com/sharifmarat/nextcloud-gallery

In nutshell the script does:

1. Finds all the images based on tag identifier.
2. Finds a full path to an image.
3. Creates thumbnails of 3 types (small, gallery-view and original for downloads).
4. Creates a simple static webpage based of nanogallery2.

After that any HTTP server will be able to serve your gallery.

The downside of this approach is that it is not fully controlled from Nextcloud interface.
It is possible to automate it with cronjobs though to minimize manual interventions.
