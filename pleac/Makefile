 #******************************************************************************
 #
 # Copyright (c) 2001 Guillaume Cottenceau <gc@mandrakesoft.com>
 #
 # PLEAC - Programming Language Examples Alike Cookbook
 #
 # Please visit:
 #
 #    http://pleac.sf.net/
 #    http://sf.net/projects/pleac
 #
 #
 # The documentation provided by this project is free documentation and can be
 # redistributed under the terms of the GNU Free Documentation Licence.
 #
 # You should have received a copy of the GNU Free Documentation License.
 # If not, please find it here: http://www.gnu.org/copyleft/fdl.html
 #
 #*****************************************************************************


IMPLS = ruby perl


HTMLTARGETS = $(addprefix pleac_, $(IMPLS))
HTMLTARGETSDEP = $(addsuffix /index.html, $(HTMLTARGETS))

PSTARGETS = $(addsuffix .ps, $(addprefix pleac_, $(IMPLS)))


all: $(PSTARGETS) $(HTMLTARGETSDEP)

clean:
	rm -rf *.ps *.dvi *.log *.aux *.tex *.sgml $(HTMLTARGETS)

%.sgml: %.data
	./generate_sgml.rb $< $@

$(PSTARGETS): %.ps: %.sgml
	db2ps $<

$(HTMLTARGETSDEP): $(HTMLTARGETS)

$(HTMLTARGETS): %: %.sgml
	rm -rf $@
	db2html $<
	mv $@/t1.html $@/index.html
