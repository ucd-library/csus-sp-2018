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
    --agent quinn@ucdavis.edu \
    --agent enebeker@ucdavis.edu


## add all files in the eastman-example directory using base filename as member id
fin collection relation add-container ${collection} catalogs -T part
fin cd /collection/${collection}

for cat in */index.ttl; do
  n=$(dirname $cat)
  id=catalogs/$n;
  fin collection resource add ${collection} ${cat} ${id}
  # Make Media, add in the pdf files.
  fin collection relation add-container -T media --metadata ${cat} ${collection} $id/media
  fin collection resource add --type MediaObject ${collection} ${n}/media/${n}.pdf ${id}/media/pdf
  fin collection resource add --type MediaObject ${collection} ${n}/ocr.txt ${id}/media/generated_text
  fin collection resource add ${collection} ${n}/media/images/index.ttl ${id}/media/images
  #  fin collection relation add-container ${collection} $id/media/images/images -T part
  fin http patch --data-string "PREFIX s: <http://schema.org/> PREFIX ldp: <http://www.w3.org/ns/ldp#> INSERT {<> ldp:hasMemberRelation s:hasPart ; ldp:isMemberOfRelation s:partOf; ldp:membershipResource <>. } WHERE {} " -P h ${id}/media/images ;
  for f in $n/media/images/$n-*; do
    b=$(basename $f .jpg)
    p=${b#*-}
    #    fin collection resource add --type MediaObject ${collection} ${f} ${id}/media/images/images/$b
    fin collection resource add --type MediaObject ${collection} ${f} ${id}/media/images/$b
    ins="INSERT {<> <http://schema.org/position> $p } WHERE {}"
    fin http patch --data-string "$ins" -P h ${id}/media/images/$b/fcr:metadata ;
  done

  fin collection relation add-properties ${collection} http://schema.org/workExample $id/media/images/$n-0 http://schema.org/exampleOfWork $id
done

fin collection relation add-properties  ${collection} http://schema.org/workExample catalogs/199/media/images/199-0 http://schema.org/exampleOfWork