#!/bin/sh

OLDSPECVERSION=$1
SPECVERSION=$2

VERSIONS=`ls -d -1 0.* | sort -r -g`

rfcdiff --html --width 80 --stdout $OLDSPECVERSION/spec.txt $SPECVERSION/spec.txt | perl -pe 's/charset=iso-8859-1/charset=utf-8/' > $SPECVERSION/changes.html

echo "% CommonMark Spec"
echo ""
date=`grep '<div class="version">' $SPECVERSION/index.html | perl  -pe 's/^.*(\d\d\d\d-\d\d-\d\d).*$/\1/'`
echo "[**Latest version ($SPECVERSION)**](current/) ($date)"
echo ""
echo "[discussion forum](http://talk.commonmark.org/) | "
echo "[interactive dingus](dingus/) | "
echo "[repository](https://github.com/commonmark/commonmark-spec/) | "
echo "[changelog](changelog.txt)"
echo ""
echo "All versions:"
echo ""
for vers in $VERSIONS
  do
    date=`grep '<div class="version">' $vers/index.html | perl  -pe 's/^.*(\d\d\d\d-\d\d-\d\d).*$/\1/'`
    if [ "$vers" != "$SPECVERSION" ]; then
	perl -p -i -e 's/<div id="watermark">.*?<\/div>/<div id="watermark" style="background-color:black">This is an older version of the spec. For the most recent version, see <a href="http:\/\/spec.commonmark.org">http:\/\/spec.commonmark.org<\/a>.<\/div>/' $vers/index.html
    fi
        changes=""
        [ -f $vers/changes.html ] && changes=" ([view changes]($vers/changes.html 'See changes from previous version') | [test cases]($vers/spec.json 'JSON test cases'))"
        echo "- [$vers]($vers/) ($date)$changes"
  done | sort -r -k3
