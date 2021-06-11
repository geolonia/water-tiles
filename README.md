# water-tiles

OpenStreetMap データから water のレイヤーしか入っていない mbtiles を作るツール

[Data Derived from OpenStreetMap for Download](https://osmdata.openstreetmap.de/data/water-polygons.html) から water polygons の WGS84 shapefile をダウンロードして、 `build/water.mbtiles` の出力ファイルを作成します。

## 環境依存

* gdal
* tippecanoe
* sqlite3 (cli)

## 使い方

```
$ ./generate.sh
```
