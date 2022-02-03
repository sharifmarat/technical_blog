---
Title: Real-time Dutch train traffic
Date: 2017-05-23
Comments: true
Type: "post"
---

Following the previous article I reconstructed a "real-time" train traffic through a single day.

<!--more-->

Here it is (~20MB):
<video width="503" height="644" controls>
  <source src="trains.mp4" type="video/mp4">
Your browser does not support the video tag.
</video>

## Issues:
1. Not all trains follow tracks (it has to do with linear interpolation, see below)
2. A train never reaches its final stop (not enough data, see below)
3. These are not true train positions, interpolated between stations
4. It's getting quite repetitve after some time :)

## How is was done?
1.Got access to NS API

2.Mapped all train stations which includes stations both within the Netherlands and outside.
Example of response containing information with traion stations:

``` xml
<Station>
 <Code>HLM</Code>
 <Type>knooppuntIntercitystation</Type>
 <Namen>
  <Kort>Haarlem</Kort><Middel>Haarlem</Middel><Lang>Haarlem</Lang>
 </Namen>
 <Land>NL</Land>
 <UICCode>8400285</UICCode>
 <Lat>52.3877792358398</Lat>
 <Lon>4.63833332061768</Lon>
</Station>
```

3.Filter out non-Dutch train stations.
There are approximately 400 train stations in the Netherlands (according to NS API).

4.Run a crontab script to collect departure times at every station hourly:

``` bash
for station in `cat stations_codes_nl.txt`; do
  timestamp=`date +"%Y_%m_%d_%H_%M"`
  filename="results/$station/timetable-$station-$timestamp.xml"
  curl --user LOGIN:PSWD https://webservices.ns.nl/ns-api-avt?station=$station > $filename
done
```

5.It produces lots of files with departure information, e.g.:

``` xml
<RitNummer>2233</RitNummer> <!-- train number, unique within the same day -->
<VertrekTijd>2017-05-16T10:10:00+0200</VertrekTijd>  <!-- departure time from this station -->
<EindBestemming>Amsterdam Centraal</EindBestemming> <!-- the final destination -->
<TreinSoort>Intercity</TreinSoort> <!-- train type -->
```

6.Find all trains on that day (grepping RitNummer)

7.Reconstruct a route (array with pairs of station/departure time) for every train.

8.Interpolate train movements between stations

9.Place them on the map and make lots of pngs (thanks to python + basemap)

10.pngs -> ffmpeg -> video :)


[Source code can be found here](https://github.com/sharifmarat/trains)

## What's next?
It's quickly getting repetitive. The simplest way to make it more entertaining is to get data
from 3am or 4am. It would be more fun to see build up of train traffic.

With such limited data it is quite hard to make all trains follow the track. 
The data does not contain all stations a single train moves through. One way to fix it would be to map
all train tracks, find a shortest (?) route from station A to station B and make the train to follow it.

The final stop is also hard to fix properly. The data does not contain time when a train arrives to its
final destination. Can be fixed with extrapolation on the last segment.
