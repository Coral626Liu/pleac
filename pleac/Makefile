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


IMPLS = perl python ruby guile merd ada tcl haskell java pliant ocaml commonlisp c++ pike erlang forth php masd nasm 


HTMLTARGETS = $(addprefix pleac_, $(IMPLS))
HTMLTARGETSDEP = $(addsuffix /t1.html, $(HTMLTARGETS))

PSTARGETS = $(addsuffix .ps, $(addprefix pleac_, $(IMPLS)))


all: $(HTMLTARGETSDEP) 

clean:
	rm -rf index.html pleac_*.html skeleton $(HTMLTARGETS)

skeleton/t1.html: skeleton.sgml
	rm -rf $@
	db2html $<

%.html: %.data
	./code2html $<

$(HTMLTARGETSDEP): %/t1.html: %.html skeleton/t1.html
	rm -rf $(@D)
	cp -a skeleton $(@D)
	for i in $(@D)/*.html; do ./substitute.rb $$i $(@D).html ; done
	./genpercentages.rb $(@D)/t1.html $(@D).data skeleton.sgml

web:
	total=`grep "PLEAC:[0-9].*:CAELP" skeleton.sgml | wc -l` ; \
	cp index-skeleton.html index.html ; \
	ruby -pi -e "sub(/@LASTUPDATE@/, '`date`')" index.html ; \
	echo "<ul> " > webcontents ; \
	for i in $(IMPLS); \
	do \
		echo "<li>" >> webcontents; \
		done=`grep "..PLEAC.._[0-9].*" pleac_$$i.data | wc -l`; \
		incomp=`grep "@@INCOMPLETE@@" pleac_$$i.data | wc -l`; \
		percent=`ruby -e "printf \"%.2f\n\", ($$done-0.5*$$incomp)*100/Float($$total)"`; \
		echo "" >> webcontents; \
		echo "<a href=\"pleac_$$i/t1.html\">$$i</a>, $$percent% done " >> webcontents; \
		echo "(<a href=\"pleac_$$i.data\">raw source</a>, <a href=\"pleac_$$i.html\">colorized source</a>)" >> webcontents; \
		echo "</li>" >> webcontents; \
	done  
	echo "</ul> " >> webcontents
	ruby -pi -e "sub(/@CURRENTVERSIONS@/, '`cat webcontents`')" index.html
	rm -f webcontents

upload: all web
	rm -rf ../t
	mkdir ../t
	cp -a * ../t
	cd ../t; rm -rf `find -type d -name CVS`; scp -r * ggc@shell.sourceforge.net:/home/groups/p/pl/pleac/htdocs
#	cd ../t; rm -rf `find -type d -name CVS`; scp -r * mandrakesoft.com:www/pleac
	rm -rf ../t
