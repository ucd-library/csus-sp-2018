#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

## Create the collection (remove if exists)
fin collection delete -f example_1-pets
fin collection create example_1-pets index.ttl

fin cd /collection/example_1-pets
## Add a thumbnail
#fin http put -@ thumbnail.png -P b thumbnail
#fin http patch -@ /dev/stdin <<< 'prefix s: <http://schema.org/> insert {<> s:thumbnail <example_1-pets/thumbnail> } WHERE {}' -P h

fin collection relation add-container example_1-pets pets -T part

for file in *.jpg
do
  id=`basename $file .jpg`;
  fin collection resource add -t ImageObject -m $file.ttl example_1-pets ./$file pets/$id
done

fin collection resource add example_1-pets -H "Content-Type: application/octet-stream" ./wiki.hdt wiki-graph

fin collection relation add-properties example_1-pets http://schema.org/workExample pets/mochi http://schema.org/exampleOfWork
fin collection relation add-properties example_1-pets http://digital.ucdavis.edu/schema#hasGraph wiki-graph http://digital.ucdavis.edu/schema#isGraph