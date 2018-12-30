#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage $0 <api_key>"
  exit 1
fi

wget -q "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=$1&per_page=500&format=json" -O photos.js
