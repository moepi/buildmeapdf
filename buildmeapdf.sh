#!/bin/bash
WGETBIN="`which wget`"
PDFLATEXBIN="`which pdflatex`"
PDFVIEWER="`which zathura`"
TMPDIR="/tmp/buildmeapdf"
TMPFILENAME="pad"

function usage {
cat << EOF
usage: $0 url
This is a stupid little bash script getting tex-source from an etherpads/etherpad-lites and building a pdf.
EOF
exit 1
}

[[ $# -eq 1 ]] && URL=$1 || usage

# for now we just sed over the URL multiple times
# the one that matches wins
# etherpad URL layout
# https://piratenpad.de/ID
# to
# https://piratenpad.de/ep/pad/export/ID/latest?format=txt
#
# this one is ugly - has anyone a better idea?

PADEXP="`echo $URL | sed 's/.*piratenpad.de\/\(.*\).*/https:\/\/piratenpad.de\/ep\/pad\/export\/\1\/latest?format=txt/'`"
PADEXP="`echo $PADEXP | sed 's/.*piratepad.net\/\(.*\).*/https:\/\/piratepad.net\/ep\/pad\/export\/\1\/latest?format=txt/'`"
PADEXP="`echo $PADEXP | sed 's/.*titanpad.com\/\(.*\).*/https:\/\/titanpad.com\/ep\/pad\/export\/\1\/latest?format=txt/'`"

# etherpad lite URL layout
# http://beta.etherpad.org/p/ID
# to
# http://beta.etherpad.org/p/ID/export/txt
#
PADEXP="`echo $PADEXP | sed 's/\(http.*\/r\/[a-Z0-9]*$\)/\1\/export\/txt/'`"

mkdir -p $TMPDIR
TMPFOLDER="`mktemp -d --tmpdir=$TMPDIR`"
WGETTEX="$WGETBIN -q $PADEXP -O $TMPFOLDER/$TMPFILENAME.tex"
BUILDPDF="$PDFLATEXBIN -interaction=batchmode -output-directory $TMPFOLDER $TMPFOLDER/$TMPFILENAME.tex 1>/dev/null"

echo "tempfolder: $TMPFOLDER"

$WGETTEX || exit 2
$BUILDPDF || exit 3
rm $TMPFOLDER/*.{aux,log} && $PDFVIEWER $TMPFOLDER/$TMPFILENAME.pdf
