---
title: Map matching 101 - part 1
author: marat
date: 2017-08-31
template: article.jade
comments: true
---

Map matching is an interesting problem which is used in car navigation,
self-driving cars, traffic analysis, map correction and more.
Let's write a simple map matching algorithm in Julia.

<span class="more"></span>

# Map matching

Map matching is the process of estimating actual trajectory traveled by a vehicle/bicycle
on a road network (map) from certain observations. These observations could be:
* track points of Global Navigation Satellite System (e.g. GPS, GLONASS, Galileo)
* sensor data (e.g. LiDAR, gyroscope, accelerometer)
* known locations of mobile network cell sites
* even Wi-Fi access points

All these observations contain measurement/hardware errors.
A digital road network (map) does not match real world either.
Map matching algorithms suppose to account for such
inaccuracies and estimate actual locations on the road network.

# Julia

It can be done in almost any programming language. But I decided to go with 
[Julia](https://julialang.org/) as it is a fairly new programming
language made specifically for high-level and high-performance numerical computing.
Julia's backend is LLVM and it supports Lisp-like macros.
I think it is worth trying Julia as an alternative to expensive
and buggy (especially on Linux) MATLAB. 

# Map data
To map match input observations a digital map data must be available.
OpenStreetMap can expose all its map data in a single file.
There are also extracts which contain OpenStreetMap data for individual countries,
cities and areas of interest. See [Planet.osm](https://wiki.openstreetmap.org/wiki/Planet.osm) for 
more information. To extract your own region you can use [bbbike.org](https://download.bbbike.org/osm/).

OpenStreetMap mainly uses two of the following formats:
* OSM XML is a human readable format  
* PBF is a binary format design for faster access and smaller size

I'm going to use Amsterdam's extract in OSM XML format. The extract contains data primitives:
nodes, ways and relations.

## Node
It is represented by identifier, latitude and longitude. It can represent some standalone
features or shape of continuous ways.

## Way
A way is an ordered list of nodes to represent linear features like rivers, roads, boundaries ("closed way").

## Relation
A relation represents a relationship between two or more elements.

## Example:
``` xml
        <node id="16568166" lat="52.3776574" lon="4.8988379" version="1">
                <tag k="ref" v="29-V"/>
                <tag k="railway" v="switch"/>
        </node>
        <node id="16568167" lat="52.3777968" lon="4.899034" version="1"/>
        <node id="25596477" lat="52.367" lon="4.9060967" version="1"/>

        <way id="7045991" version="1">
                <nd ref="46385578"/>
                <nd ref="252129511"/>
                <nd ref="330036893"/>
                <nd ref="46384590"/>
                <tag k="ref" v="s116"/>
                <tag k="name" v="Kattenburgerplein"/>
                <tag k="lanes" v="1"/>
                <tag k="oneway" v="yes"/>
                <tag k="bicycle" v="use_sidepath"/>
                <tag k="highway" v="secondary"/>
                <tag k="surface" v="asphalt"/>
                <tag k="maxspeed" v="50"/>
        </way>

        <relation id="2816" version="1">
                <member type="way" ref="382853413" role=""/>
                <member type="way" ref="504938884" role=""/>
                <tag k="ref" v="LF2"/>
                <tag k="name" v="Stedenroute"/>
                <tag k="type" v="route"/>
                <tag k="route" v="bicycle"/>
                <tag k="remark" v="relation contains two alternative routes"/>
                <tag k="network" v="ncn"/>
        </relation>
```

# Observations (GNSS)
OpenStreetMap also provides access to huge
[database with GNSS traces](https://wiki.openstreetmap.org/wiki/Planet.gpx).
These traces can be used to test map matching algorithms.

The format used is [GPX or GPS Exchange Format](https://en.wikipedia.org/wiki/GPS_Exchange_Format).

Example:
``` xml
<?xml version='1.0' encoding='utf-8'?>
<gpx xmlns="http://www.topografix.com/GPX/1/0" version="1.0" creator="OSM gpx_dump.py">
  <trk>
    <name>Track 0</name>
    <number>0</number>
    <trkseg>
      <trkpt lat="52.0709250" lon="5.1255720">
        <ele>11.19</ele>
      </trkpt>
      <trkpt lat="52.0729630" lon="5.1228470">
        <ele>-1.79</ele>
      </trkpt>
```

# To be continued
In the next posts I'm going to write a program which loads map data, plots a GPS trace and
start with map matching.

