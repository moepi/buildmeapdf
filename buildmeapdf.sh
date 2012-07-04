#!/bin/bash
WGETBIN="`which wget`"
PDFLATEXBIN="`which pdflatex`"
PDFVIEWER="`which zathura`"
TMPDIR="/tmp/buildmeapdf"
TMPFILENAME="pad"
URL=$1
#piratenpad URL layout
#https://piratenpad.de/$ID
#https://piratenpad.de/ep/pad/export/$ID/latest?format=txt
#
PADEXP="`echo $URL | sed 's/.*piratenpad.de\/\(.*\).*/https:\/\/piratenpad.de\/ep\/pad\/export\/\1\/latest?format=txt/'`"
#

mkdir -p $TMPDIR
TMPFOLDER="`mktemp -d --tmpdir=$TMPDIR`"
WGETTEX="$WGETBIN -q $PADEXP -O $TMPFOLDER/$TMPFILENAME.tex"
BUILDPDF="$PDFLATEXBIN -interaction=batchmode -output-directory $TMPFOLDER $TMPFOLDER/$TMPFILENAME.tex 1>/dev/null"

echo "tempfolder: $TMPFOLDER"

$WGETTEX || exit 1
$BUILDPDF || exit 2
rm $TMPFOLDER/*.{aux,log} && $PDFVIEWER $TMPFOLDER/$TMPFILENAME.pdf
