# type "make" command in Unix to create $MAINFILE.pdf file
MAINFILE=twelf_slides

all:
	pdflatex $(MAINFILE).tex
	pdflatex $(MAINFILE).tex

clean:
	rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg \
	  $(MAINFILE).out $(MAINFILE).nav $(MAINFILE).snm $(MAINFILE).vrb

distclean: clean
	rm -f $(MAINFILE).pdf
