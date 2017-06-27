---
title: Percolation
author: marat
template: page.jade
comments: true
---

Imagine the grid where every pixel is open with some probability *p*.
What is the probability to get from left side of the grid to right via open pixels (long-range connectivity)?

<canvas id="canvas" width="400" height="400" style="background: #eee; display: block; margin: 0 auto; "></canvas>

<br>
**Result**: <label id="result"></label>
<br>
Probability to enable a pixel (0 to 100): <input id="prob" type="number" value="65" min="0" max="100"></input>
<br>
Pixel size: <select id="pixelSize">
  <option value="1">1</option>
  <option value="2">2</option>
  <option value="4" selected="selected">4</option>
  <option value="8">8</option>
  <option value="10">10</option>
  <option value="20">20</option>
  <option value="40">40</option>
</select>
<input type="submit" onclick="update(true);" style="background:#c9c9c9;" value="Redraw"><br>

*Note*: If you want to get an idea of critical percolation threshold (high probability that long-range connectivity occurs),
it is possible to run multiple iterations for all probabilities (0 to 100) and calculate how many times 
long-range connectivity occured. In order to do it, open developer's console in browser and execute:
``` javascript
>> simulate(20); //for every input prob runs 20 iterations to calculate prob of long-range connectivity
probability to enable pixel = 0 probability of long-range connectivity = 0
probability to enable pixel = 0.01 probability of long-range connectivity = 0
....
probability to enable pixel = 0.59 probability of long-range connectivity = 0
probability to enable pixel = 0.6 probability of long-range connectivity = 0.15
probability to enable pixel = 0.61 probability of long-range connectivity = 0.35
probability to enable pixel = 0.62 probability of long-range connectivity = 0.7
probability to enable pixel = 0.63 probability of long-range connectivity = 0.9
...
```

<script>
var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");
var colorOn = "#FF8C00";
var colorOff = "#ADD8E6";
var colorPath = "#8B0000";
update(true);

function update(draw)
{
  var resultLabel = document.getElementById("result");
  resultLabel.innerText = "calculating...";

  var prob = parseInt(document.getElementById("prob").value);
  if (isNaN(prob) || !isFinite(prob) || prob < 0 || prob > 100) {
    resultLabel.innerText = 'probability must be between 0 and 100';
    return false;
  }

  var pixelSizeSelect = document.getElementById("pixelSize");
  var pixelSize = parseInt(pixelSizeSelect.options[pixelSizeSelect.selectedIndex].value);
  if (isNaN(pixelSize) || !isFinite(pixelSize) ||
      pixelSize <= 0 || pixelSize >= canvas.width || pixelSize >= canvas.height ||
      canvas.width % pixelSize != 0 || canvas.height % pixelSize != 0) {
    resultLabel.innerText = 'pixel size must be a factor of width and height';
    return false;
  }
  var maxX = canvas.width/pixelSize;
  var maxY = canvas.height/pixelSize;
  var grid = [];

  for (var x = 0; x < maxX; ++x) {
    var row = [];
    for (var y = 0; y < maxY; ++y) {
      var col;
      if (Math.random() < prob/100.) {
        row.push({enabled:true, expanded:false, parent:{x:x, y:y}});
        col = colorOn;
      } else {
        row.push({enabled:false, expanded:false, parent:{x:x, y:y}});
        col = colorOff;
      }
      if (draw) {
        ctx.beginPath();
        ctx.rect(x*pixelSize, y*pixelSize, pixelSize, pixelSize);
        ctx.fillStyle = col;
        ctx.fill();
        ctx.closePath();
      }
    }
    grid.push(row);
  }

  // DFS expansion from left to right to find percolation
  var frontier = [];
  for (var y = 0; y < maxY; ++y) {
    if (grid[0][y].enabled) {
      frontier.push({x:0, y:y});
      grid[0][y].expanded = true;
    }
  }
  var finish;
  while (frontier.length != 0) {
    path = frontier.splice(-1, 1);
    x = path[0].x;
    y = path[0].y;
    if (y + 1 < maxY && grid[x][y + 1].enabled && !grid[x][y + 1].expanded) {
      frontier.push({x:x, y:y+1});
      grid[x][y + 1].expanded = true;
      grid[x][y + 1].parent = {x:x, y:y};
    }
    if (y - 1 >= 0 && grid[x][y - 1].enabled && !grid[x][y - 1].expanded) {
      frontier.push({x:x, y:y-1});
      grid[x][y - 1].expanded = true;
      grid[x][y - 1].parent = {x:x, y:y};
    }
    if (x + 1 < maxX && grid[x + 1][y].enabled && !grid[x + 1][y].expanded) {
      frontier.push({x:x+1, y:y});
      grid[x + 1][y].expanded = true;
      grid[x + 1][y].parent = {x:x, y:y};
      if (x + 1 == maxX - 1) {
        finish = {x:x+1, y:y}
        break;
      }
    }
  }
  if (!finish) {
    resultLabel.innerText = "Path IS NOT found :(";
    return false;
  }

  resultLabel.innerText = "Path IS found";
  // draw path from finish to begin
  while (draw) {
    ctx.beginPath();
    ctx.rect(finish.x * pixelSize, finish.y * pixelSize, pixelSize, pixelSize);
    ctx.fillStyle = colorPath;
    ctx.fill();
    ctx.closePath();
    parent = grid[finish.x][finish.y].parent;
    if (parent.x == finish.x && parent.y == finish.y) {
      break;
    }
    finish = parent;
  }
  return true;
}

function simulate(nIter) {
  for (var p = 0; p <= 100; ++p) {
    var nPercolate = 0;
    for (var iter = 0; iter < nIter; ++iter) {
      document.getElementById("prob").value = p;
      if (update(false)) {
        nPercolate += 1;
      }
    }
    console.log('probability to enable pixel = ' + p/100.0 + ' probability of long-range connectivity = ' + nPercolate/nIter);
  }
}

</script>

