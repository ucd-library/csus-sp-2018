#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

COLLECTION=example_6-library-3d

## Create the collection (remove if exists)
fin collection delete -f $COLLECTION
fin collection create $COLLECTION index.ttl

fin cd /collection/$COLLECTION

fin collection relation add-container $COLLECTION scenes -T part
fin collection relation add-container $COLLECTION maps -T part

for file in scenes/*.jpg
do
  id=`basename $file .jpg`;
  fin collection resource add -t ImageObject -m $id.jpg.ttl $COLLECTION ./$file scenes/$id
done

for file in maps/*.png
do
  id=`basename $file .png`;
  fin collection resource add -t ImageObject -m $id.png.ttl $COLLECTION ./$file maps/$id
done

fin collection relation add-properties $COLLECTION http://schema.org/workExample scenes/Library360-AmerineRoom http://schema.org/exampleOfWork