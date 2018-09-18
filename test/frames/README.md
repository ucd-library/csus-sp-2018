# JSONLD - Frames

These tests are meant to show the utility of using JSON-LD Frames as a method to
create application specific JSON files. The examples shown here identify a
simple example that will take a particular Eastman file, and create a JSON file
more suitable for indexing by elastic search.

This requires the jsonld application.



``` bash
id=B-10006
fin cd collection/eastman-example/members
fin http head -P b ${id}/fcr:metadata > $id.json
jsonld frame --explicit=true --frame=es_frame.json $id.json > ${id}_es.json
```
