DOC = main
DEPS = main.md main.bib

.PHONY: all view

all: report

report: $(DEPS)
	pandoc $(DOC).md -o main.pdf

view: report
	xdg-open $(DOC).pdf