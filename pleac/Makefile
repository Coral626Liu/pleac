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


IMPLS = perl merd ruby


HTMLTARGETS = $(addprefix pleac_, $(IMPLS))
HTMLTARGETSDEP = $(addsuffix /t1.html, $(HTMLTARGETS))

PSTARGETS = $(addsuffix .ps, $(addprefix pleac_, $(IMPLS)))


all: $(HTMLTARGETSDEP) # $(PSTARGETS)

clean:
	rm -rf *.ps *.dvi *.log *.aux *.tex *.sgml index.html $(HTMLTARGETS)

%.sgml: %.data skeleton.data
	./generate_sgml.rb skeleton.data $< $@

$(PSTARGETS): %.ps: %.sgml
	db2ps $<

$(HTMLTARGETSDEP): $(HTMLTARGETS)

$(HTMLTARGETS): %: %.sgml
	rm -rf $@
	db2html $<

web:
	total=`grep "PLEAC:[0-9].*:CAELP" skeleton.data | wc -l` ; \
	cp index-skeleton.html index.html ; \
	ruby -pi -e "sub(/@LASTUPDATE@/, '`date`')" index.html ; \
	echo "<ul> " > webcontents ; \
	for i in $(IMPLS); \
	do \
		echo "<li>" >> webcontents; \
		done=`grep "@@@[0-9].*" pleac_$$i.data | wc -l`; \
		percent=`ruby -e "printf \"%.2f\n\", $$done*100/Float($$total)"`; \
		echo "<b>$$i:</b> <a href=\"pleac_$$i.data\">code</a>, " >> webcontents; \
		echo "  <a href=\"pleac_$$i/t1.html\">html version</a> ($$percent% done)" >> webcontents; \
		echo "</li>" >> webcontents; \
	done  
	echo "</ul> " >> webcontents
	ruby -pi -e "sub(/@CURRENTVERSIONS@/, '`cat webcontents`')" index.html
	rm -f webcontents

upload: all web
	rm -rf ../t
	mkdir ../t
	cp -a * ../t
#	cd ../t; rm -rf `find -type d -name CVS`; scp -r * ggc@shell.sourceforge.net:/home/groups/p/pl/pleac/htdoc
	cd ../t; rm -rf `find -type d -name CVS`; scp -r * mandrakesoft.com:www/pleac
	rm -rf ../t
