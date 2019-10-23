DOC = main.tex

OTHERSOURCES := $(filter-out $DOC, $(wildcard *.tex))
PDFLATEX = pdflatex -synctex=1 --shell-escape
BIBTEX = bibtex
RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"
TARDIR = $(DOC:.tex=-src)

.PHONY: pdf clean

pdf: $(DOC:.tex=.pdf)

all: pdf

%.pdf: %.tex $(OTHERSOURCES)
	${PDFLATEX} $<; ${PDFLATEX} $<
	egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(PDFLATEX) $<;$(PDFLATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(PDFLATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(PDFLATEX) $<) ; true
	egrep -i "(Reference|Citation).*undefined" $*.log ; true

clean:
	@\rm -f \
        $(DOC:.tex=.aux) \
        $(DOC:.tex=.log) \
        $(DOC:.tex=.out) \
        $(DOC:.tex=.dvi) \
        $(DOC:.tex=.pdf) \
        $(DOC:.tex=.ps)  \
        $(DOC:.tex=.bbl) \
        $(DOC:.tex=.blg) \
				$(DOC:.tex=-src.tar.gz) 

veryclean: clean
	@\rm -r -f *~ *.log *.pdf *.gnuplot *.fdb_latexmk *.fls *.upa *.upb auto *.gz *.cut *.out *.aux *.cut

tar: pdf
	@test -d $(TARDIR) || mkdir $(TARDIR)
	@cp Makefile *.{tex,bib,bst,cls} $(TARDIR)
	@tar cz $(TARDIR) > $(TARDIR).tar.gz
	@rm -rf $(TARDIR)
