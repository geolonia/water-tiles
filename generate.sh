#!/bin/bash -e

if [[ ! -d ./build ]]; then mkdir ./build; fi
if [[ ! -d ./tmp ]]; then mkdir ./tmp; fi

#### Download data if not exists #####
if [[ ! -d ./tmp/water-polygons-split-4326 ]]; then
  echo "Downloading newest water polygons..."
  curl "https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip" > water-polygons-split-4326.zip
  unzip water-polygons-split-4326.zip
else
  echo "Water polygons already exist."
fi

if [[ ! -f ./tmp/water_polygons.geojsons ]]; then
  echo "Transforming shp to GeoJSONSeq..."
  ogr2ogr -f GeoJSONSeq ./tmp/water_polygons.geojsons ./tmp/water-polygons-split-4326/water_polygons.shp
else
  echo "water_polygons.geojsons already exist."
fi

if [[ ! -f ./build/water.mbtiles ]]; then
  echo "Building tiles with tippecanoe..."
  tippecanoe \
    -zg \
    -o ./build/water.mbtiles \
    --name="water" \
    --attribution="<a href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\">&copy; OpenStreetMap</a>" \
    --description="Worldwide water tiles" \
    --hilbert \
    --coalesce \
    --exclude-all \
    --coalesce-densest-as-needed \
    --extend-zooms-if-still-dropping \
    -l water \
    -P ./tmp/water_polygons.geojsons
else
  echo "water.mbtiles already exist."
fi

sqlite3 ./build/water.mbtiles < ./patch_mbtiles.sql
