---
Title: What will probably kill you
Date: 2017-07-31
Comments: true
Type: "post"
Dygraphs: true
---

Have you ever wondered what is probably going to kill you if you die at certiange age?
Based on data from Statistics Netherlands (or Centraal Bureau voor de Statistiek)
we could try to figure out main cause of death for different age groups.

<!--more-->

I've just collected the most recent data from [Statistics Netherlands (CBS)](https://www.cbs.nl)
on main cause of death at the certain age. The data is based on 2016. The following death causes are taking into account:
<img src="legend.png" alt="Legend" style="width: 276px; display: block; margin: 0 auto;" />

Age of interest is on x-axis, y-axis is split into different causes of death which should sum up to 100%.
Hover mouse over an area of interest to get actual numbers for this cause of death and age:
<div id="graph"></div>

<style>
.dygraph-legend { background: none; }
.dygraph-legend > span { display: none; }
.dygraph-legend > span.highlight { display: inline; }
</style>

<div id="graph" style="width:100%;"></div>
<div id="legend"></div>

<script>
var labels = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85];
var total = [106,55,79,183,315,366,480,608,1098,2043,3625,5564,8059,12444,14678,18383,24326];
var blood_dis = [1,2,2,2,0,6,4,4,2,5,7,11,13,36,30,48,75];
var infect = [14,0,2,4,11,6,5,12,18,20,49,88,124,205,279,326,563];
var cancer = [14,20,21,27,32,57,117,199,429,876,1774,2850,4295,6482,6925,7059,7139];
var endocr = [8,4,4,9,8,10,16,13,32,47,68,154,190,309,358,427,593];
var psych = [2,1,4,5,6,11,16,22,37,70,88,136,138,272,443,1016,2140];
var nerv_dis = [14,2,16,13,8,24,20,32,42,79,113,193,290,468,673,1138,1602];
var heart = [6,3,3,14,26,27,35,56,151,320,594,847,1340,2331,3097,4491,6847];
var respir = [4,6,1,3,9,6,8,10,29,55,147,322,512,877,1239,1748,2198];
var digestive = [2,0,0,0,5,9,11,9,37,91,132,222,317,370,437,555,711];
var skin = [0,0,0,0,0,0,1,0,0,1,1,6,7,7,17,20,40];
var conn_tissue = [0,0,0,1,6,1,0,7,10,10,21,26,42,78,93,118,204];
var urogen = [0,0,1,1,1,1,3,6,7,13,17,40,56,106,195,325,617];
var birth_defects = [12,5,1,7,7,7,5,8,12,18,44,60,52,29,10,8,5];
var abnormal_stuff = [8,3,3,12,27,17,39,47,70,127,193,260,320,498,484,525,618];
var transport_accidents = [7,4,8,32,54,39,24,20,19,37,43,39,31,47,43,59,76];
var accidental_falls = [3,1,0,3,6,1,4,1,14,25,40,50,82,128,192,355,679];
var accidental_drown = [4,3,3,3,2,3,1,6,5,6,4,5,8,10,6,10,2];
var accidental_pois = [0,0,0,3,16,18,25,14,22,17,17,15,8,9,4,5,8];
var accidents_other = [5,1,1,2,6,7,9,6,8,10,14,17,15,20,21,20,38];
var suicides = [0,0,9,39,73,102,122,118,142,195,239,208,197,140,100,86,60];
var assaults = [1,0,0,3,8,9,12,12,7,8,10,3,1,5,4,2,3];
var other_external = [1,0,0,0,4,2,2,4,5,13,10,12,21,17,27,42,108];

var data = [];
for (var age_group = 0; age_group < 17; ++age_group) {
  var arr = [];

  arr.push(labels[age_group]);

  arr.push(100 * endocr[age_group] / total[age_group]);
  arr.push(100 * psych[age_group] / total[age_group]);
  arr.push(100 * infect[age_group] / total[age_group]);
  arr.push(100 * cancer[age_group] / total[age_group]);
  arr.push(100 * nerv_dis[age_group] / total[age_group]);
  arr.push(100 * heart[age_group] / total[age_group]);
  arr.push(100 * respir[age_group] / total[age_group]);

  var other_medical = blood_dis[age_group] + digestive[age_group] + conn_tissue[age_group] + skin[age_group] + birth_defects[age_group] + abnormal_stuff[age_group] + urogen[age_group];
  arr.push(100 * other_medical / total[age_group]);

  var accidents = transport_accidents[age_group] + accidental_falls[age_group] + accidental_drown[age_group] + accidental_pois[age_group] + accidents_other[age_group];
  arr.push(100 * accidents / total[age_group]);
  arr.push(100 * suicides[age_group] / total[age_group]);

  arr.push(100 * (assaults[age_group] + other_external[age_group]) / total[age_group]);

  data.push(arr);
}

var labels = ['Age'];
labels.push('Endocrine diseases');
labels.push('Mental disorders');
labels.push('Infectious diseases');
labels.push('Malignant neoplasms');
labels.push('Nervous system diseases');
labels.push('Circulatory diseases');
labels.push('Respiratory diseases');
labels.push('Other health related deths');
labels.push('Accidents');
labels.push('Suicides');
labels.push('Assaults');

var g = new Dygraph(
    document.getElementById('graph'),
    data,
    {
      labels: labels.slice(),
      stackedGraph: true,
      xlabel: 'age',
      ylabel: 'percentage',

      //labelsDiv: 'legend',
      //labelsSeparateLines: true,
      //legend: 'always',

      highlightCircleSize: 2,
      strokeWidth: 1,
      strokeBorderWidth: null,

      highlightSeriesOpts: {
        strokeWidth: 3,
        strokeBorderWidth: 1,
        highlightCircleSize: 5
      }
    });
var updateSelection = function(ev) {
  if (g.isSeriesLocked()) {
    g.clearSelection();
  } else {
    g.setSelection(g.getSelection(), g.getHighlightSeries(), true);
  }
};
g.updateOptions({clickCallback: updateSelection}, true);
g.setSelection(false, 'Circulatory diseases');

</script>
