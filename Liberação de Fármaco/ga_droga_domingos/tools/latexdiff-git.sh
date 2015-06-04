#!/bin/bash
TMPDIR=$(mktemp -d /tmp/git-latexdiff.XXXXXX)
latexdiff "$1" "$2" > $TMPDIR/diff.tex
pdflatex -interaction nonstopmode -output-directory $TMPDIR $TMPDIR/diff.tex
#pdflatex -interaction batchmode -output-directory $TMPDIR $TMPDIR/diff.tex
xdg-open $TMPDIR/diff.pdf
#rm -rf $TMPDIR
$(rm -rf $TMPDIR) EXIT
