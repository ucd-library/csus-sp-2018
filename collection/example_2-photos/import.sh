#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# The collection is the directory name
collection=`basename $DIR`

## Create the collection (remove if exists)
fin collection delete -f ${collection}
fin collection create ${collection} index.ttl

# Admins can write
fin collection acl group add \
    $collection admins rw \
    --agent jrmerz@ucdavis.edu \
    --agent qjhart@ucdavis.edu

fin cd /collection/${collection}

## add all files in the eastman-example director using base filename as member id
for d in `find * -maxdepth 0 -type d`;
do
  fin collection relation add-container ${collection} $d -T part
  for photo in `find $d -name index.ttl`;
  do
    id=$(dirname $photo);
    fin collection resource add ${collection} ${photo} ${id}
    fin collection relation add-container -T media --metadata $photo ${collection} $id/media
    for media in $id/media/*; do
      fin collection resource add --type MediaObject ${collection} ${media} ${id}/media/$n
    done
  done
done

fin collection relation add-properties  ${collection} http://schema.org/workExample B-1/B-1/media/full http://schema.org/exampleOfWork
