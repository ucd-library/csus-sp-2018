#! /usr/bin/make -f

cats:=199 200 201 202 203

cats_json:=$(patsubst %,%/json,${cats})
cats_ocr:=$(patsubst %,%/ocr,${cats})
cats_pages:=$(join $(patsubst %,%/media/image_list/,${cats}),$(patsubst %,%-0.png,${cats}))
cats_media:=$(join $(patsubst %,%/media/image_list/,${cats}),$(patsubst %,)

api:=https://wine-api.library.ucdavis.edu/

cat_199:=	6313c5ca-fff4-4565-9ea7-e7f85f07a1e4
cat_200:=	a1f5cc05-fcbb-42f8-b255-3c05163d318a
cat_201:= e75d7638-f3bb-4445-ab91-0159dfea0432
cat_202:= 8d034005-287b-4bf0-8443-675c56f12745
cat_203:= 8b18927d-e383-4fa1-971e-7c17ef1b1453

title_199:=Great Mid Winter Sale March 1967
title_200:=Sale February 1963
title_201:=Wall Street Journal December 1968
title_202:=Newsletter. Price list 1967
title_203:=Exciting Wine News from Burgundy 1961

INFO:
	echo ${cats_pages}

.PHONY:json ocr

json: ${cats_json}
ocr: ${cats_ocr}
pages: ${cats_pages}

${cats_json}:%/json:
	curl '${api}/catalogs?catalog_id=eq.${cat_$*}' | jq . > $@

${cats_ocr}:%/ocr:
	curl '${api}/media?select=ocr&media_id=eq.${cat_$*}' > $@

${cats_pages}:%/media/image_list/foo:
	convert $*/media/$*.pdf $*/media/image_list/$*.jpg
