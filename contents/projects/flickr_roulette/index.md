---
title: Flickr Roulette
author: marat
template: page.jade
comments: true
---

<div style="text-align:center;"><input type="submit" onclick="reload();" style="background:#c9c9c9;" value="Update"></div><br/>

<div><img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" id="pic" style="width:100%;"/></div><br/>

<label id="source"></label>

<script>
function jsonFlickrApi(obj) {
  var p = obj.photos.photo[Math.floor(Math.random() * obj.photos.total)];
  var raw_url = "http://farm" + p.farm + ".static.flickr.com/" + p.server + "/"+ p.id + "_" + p.secret + "_b.jpg";
  var flickr_url = "https://www.flickr.com/photos/" + p.owner + "/" + p.id;
  document.getElementById("pic").src = raw_url;
  document.getElementById("source").innerText = "Check the license " + flickr_url + " before using this photo";
}

function reload() {
  var head = document.getElementsByTagName('head')[0];
  var script = document.createElement('script');
  script.type= 'text/javascript';
  script.src= 'photos.js' + '?cachebuster=' + new Date().getTime();
  head.appendChild(script);
}

reload();
</script>

