#!/bin/bash
WGETBIN="$(which wget)"
PDFLATEXBIN="$(which pdflatex)"

function usage {
cat << EOF
usage: $(basename $0) url [name]
This is a stupid little bash script getting tex-source from an etherpads/etherpad-lites and building a pdf.
EOF
exit 1
}
if [[ $# -eq 1 ]]; then
	URL=$1
elif [[ $# -eq 2 ]]; then
	URL=$1
	PDFNAME=$2
else
	usage
fi

# 
# etherpad lite URL layout
# http://beta.etherpad.org/$someletter/ID
# to
# http://beta.etherpad.org/$someletter/ID/export/txt
#

PADEXP="$(echo $URL | sed 's/\(http.*\/\(r\|\p\)\/[a-Z0-9]*$\)/\1\/export\/txt/')"
#PADEXP="$(echo $URL | sed 's/.*piratenpad.de\/\(.*\).*/https:\/\/piratenpad.de\/ep\/pad\/export\/\1\/latest?format=txt/')"
#PADEXP="$(echo $PADEXP | sed 's/.*piratepad.net\/\(.*\).*/https:\/\/piratepad.net\/ep\/pad\/export\/\1\/latest?format=txt/')"
#PADEXP="$(echo $PADEXP | sed 's/.*titanpad.com\/\(.*\).*/https:\/\/titanpad.com\/ep\/pad\/export\/\1\/latest?format=txt/')"
[[ -z $PADEXP ]] && exit 2

echo "processing $PDFNAME"
[[ -n $PDFNAME ]] && JOBNAME="--jobname $PDFNAME" || PDFNAME="texput"
$WGETBIN -qO- $PADEXP | $PDFLATEXBIN $JOBNAME && rm $PDFNAME.{aux,log} && echo "pdf compiled"
