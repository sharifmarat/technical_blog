---
title: Contact
author: marat
template: page.jade
comments: false
---
<script>

var lower_bound = 32; //including
var upper_bound = 126; //excluding
var count = upper_bound - lower_bound;

function scramble(str, key, scramble = true) {
  if (key.length == 0) return str;
  var scrambled = [];

  for (var i = 0; i < str.length; ++i) {
    var key_code = key.charCodeAt(i % key.length);
    var str_code = str.charCodeAt(i);
    if (scramble) {
      scrambled.push(String.fromCharCode((str_code + key_code) % count + lower_bound));
    } else {
      var c = (str_code - lower_bound - key_code);
      var it = 0; //safe-guard
      while ((c < lower_bound || c >= upper_bound) && it < 10) {
        it += 1;
        c += count;
      }
      if (c < lower_bound || c >= upper_bound) {
        c = Math.abs(c) % count + lower_bound;
      }
      scrambled.push(String.fromCharCode(c));
    }
  }
  return scrambled.join("");
}

function unscramble(str, key) {
  return scramble(str, key, false);
}

var origValues = [];
function updateInfo(event) {
  var key = document.getElementById("key");
  var labels = [document.getElementById("email"),
                document.getElementById("phone"),
                document.getElementById("mapcode"),
                document.getElementById("w3w")];
  for (var i = 0; i < labels.length; ++i)
  {
    if (origValues.length == i) {
      origValues.push(labels[i].innerText);
    }
    labels[i].innerText = unscramble(origValues[i], key.value);
  }
  if (event.keyCode && event.keyCode == 13) {
    key.blur();
  }
}
</script>

<table align="center">
  <tbody>
    <tr><td>Email</td><td><label id="email">`VhTi6\\[dhab!dhZ</label></td></tr>
    <tr><td>Phone number</td><td><label id="phone">|(&#39;q+*)s.&%t+..</label></td></tr>
    <tr><td>Map-code</td><td><label id="mapcode">AA:q(/!;C@</label></td></tr>
    <tr><td>What3Words</td><td><label id="w3w">cd[g#icZ[V]$g]_a&#96;[e</label></td></tr>
  </tbody>
</table><br>

To decode info type the result of expression `106 + 7 × 4` here: <input id="key" type="text" name="fname" maxlength="10" size="10" onkeyup="updateInfo(event);"><input type="submit" onclick="updateInfo(event);" style="background:#c9c9c9;width:40px;" value="⏎">
