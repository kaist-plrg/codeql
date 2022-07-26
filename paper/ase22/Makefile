PACKAGE = acmart

FILE = main

all: main.pdf

$(FILE).pdf:  $(FILE).tex *.tex $(PACKAGE).cls  ACM-Reference-Format.bst
	pdflatex $<
	- bibtex $(basename $<)
	pdflatex $<
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $(basename $<).log) \
	  do pdflatex $<; done

.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).cls

clean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.cut *.hd \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi \
	*.pdf

.PHONY: all clean
