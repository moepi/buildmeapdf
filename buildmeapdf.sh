#!/bin/bash
WGETBIN="`which wget`"
PDFLATEXBIN="`which pdflatex`"
PDFVIEWER="`which zathura`"

function usage {
cat << EOF
usage: `basename $0` name url
This is a stupid little bash script getting tex-source from an etherpads/etherpad-lites and building a pdf.
EOF
exit 1
}
[[ $# -eq 2 ]] && JOBNAME=$1 && URL=$2 || usage

# for now we just sed over the URL multiple times
# the one that matches wins
# etherpad URL layout
# https://piratenpad.de/ID
# to
# https://piratenpad.de/ep/pad/export/ID/latest?format=txt
#
# expressions for this one is ugly - has anyone a better idea?
#
# etherpad lite URL layout
# http://beta.etherpad.org/p/ID
# to
# http://beta.etherpad.org/p/ID/export/txt
#

PADEXP="`echo $URL | sed 's/.*piratenpad.de\/\(.*\).*/https:\/\/piratenpad.de\/ep\/pad\/export\/\1\/latest?format=txt/'`"
PADEXP="`echo $PADEXP | sed 's/.*piratepad.net\/\(.*\).*/https:\/\/piratepad.net\/ep\/pad\/export\/\1\/latest?format=txt/'`"
PADEXP="`echo $PADEXP | sed 's/.*titanpad.com\/\(.*\).*/https:\/\/titanpad.com\/ep\/pad\/export\/\1\/latest?format=txt/'`"
PADEXP="`echo $PADEXP | sed 's/\(http.*\/r\/[a-Z0-9]*$\)/\1\/export\/txt/'`"

[[ -z $PADEXP ]] && exit 2
echo "processing"
$WGETBIN -qO- $PADEXP | $PDFLATEXBIN --jobname $JOBNAME 1>/dev/null && rm $JOBNAME.{aux,log} && echo "pdf compiled" && $PDFVIEWER $JOBNAME.pdf
