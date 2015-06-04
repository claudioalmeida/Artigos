# A Makefile to easily handle the compilation of
# presentations, made using the LaTeX class Beamer
#
# Patrick Pletscher
# 2006-03-05
#
#
# Copyright (C) 2007, 2008 by Domingos Rodrigues
#    Alguns reajustes para desenvolvimento pessoal
#
#  $Id$
#
# LaTeX flags
LATEXFLAGS = -interaction=nonstopmode

# Directory which contain the figures. Leave blank if there is none.
FIGURESDIR =
FIGURESEXT =.eps .pdf .jpg .tiff

SHELL      = /bin/bash
# LaTeX sourcecode
SRC =

# LaTeX command
TEXCMD=latex

# how the resulting files should be named
DRAFT   = ${BASEFILE:.tex=.prep.tex}
PDFFILE = ${BASEFILE:.tex=.pdf}
PSFILE  = ${BASEFILE:.tex=.ps}
DVIFILE = ${BASEFILE:.tex=.dvi}
BIBFILE = ${BASEFILE:.tex=.bib}
BBLFILE = ${BIBFILE:.bib=.bbl}
BIBMANUALFILE = ${BIBFILE:.bib=_manual.bib}

FIGURES    = ${if ${FIGURESDIR},${wildcard ${addprefix ${FIGURESDIR}/*,\
        ${FIGURESEXT}}},}

help:
	@echo "====================================================================="
	@echo "   make |option| BASEFILE=your_file.tex                              "
	@echo "    option =                                                         "
	@echo "      clean   --- delete the logs                                    "
	@echo "                                                                     "
	@echo "   make arqps                                                        "
	@echo "     shortcut (using latex)                                          "
	@echo "                                                                     "
	@echo "   make arqpdf                                                       "
	@echo "     shortcut (using pdflatex)                                       "
	@echo "                                                                     "
	@echo "====================================================================="

arqps:
	$(MAKE) clean
	$(MAKE) base BASEFILE="drug_release.tex" TEXCMD="latex" BIBFILE="drug_release.bib" BBL2BIB="no"

arqpdf:
	$(MAKE) clean
	$(MAKE) base BASEFILE="drug_release.tex" TEXCMD="pdflatex" BIBFILE="drug_release.bib" BBL2BIB="no"


# create final
base: bib ${PDFFILE}

# create list of bibtems for inclusion
bib:
ifeq ($(BBL2BIB),yes)
	@python process_bib.py -o /tmp/file.tmp ${BBLFILE}
endif


${PDFFILE}: ${BASEFILE} ${FIGURES}
	@echo "Running pdflatex for the first time..."
	${TEXCMD} -shell-escape ${BASEFILE}
ifeq ($(BBL2BIB),no)
	@bibtex ${BIBFILE:.bib=}
endif
	-@pdflatex_count=5 ;\
	while egrep -q -s \
		'(Rerun (LaTeX|to get cross-references right)|There were undefined references)' \
		${BASEFILE:.tex=.log} && [ $$pdflatex_count -gt 0 ] ;\
		do \
			echo "Re-running pdflatex..." ;\
			echo "pdflatex ${BASEFILE}" ;\
			${TEXCMD} -shell-escape ${BASEFILE} ;\
			pdflatex_count=`expr $$pdflatex_count - 1`;\
		done
ifeq (${TEXCMD},latex)
	dvips -t a4 -o ${PSFILE} ${DVIFILE}
#	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true \
#		${PSFILE} ${PDFFILE}
	ps2pdf -dPDFSETTINGS=/screen -dEmbedAllFonts=true ${PSFILE} ${PDFFILE}
endif

# delete logs, aux files, ...
clean:		
	rm -f *.aut *.aux *.bbl *.bix *.blg *.dvi *.glo *.gls\
	 *. idx *.ilg *.ind *.ist *.lof *.log *.lot *.nav *.out\
	*.pdf *.ps *.snm *.toc\
	*.bak *.bib~ *.kilepr *.prj *.sav *.tcp *.tmp *.tps *.tex~
