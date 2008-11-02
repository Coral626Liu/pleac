#!/bin/sh

for i in `seq 0 89`; do
    echo $i
    cd /tmp/pleac
    CVSROOT=:ext:ggc@pleac.cvs.sourceforge.net:/cvsroot/pleac cvs co -D "$i month ago" pleac
    cd /tmp/pleac/pleac/pleac
    make web
    grep '% done' index.html | perl -ne 'm|pleac_([^/]+).*?([\d\.]+)% done| and print "$1 $2\n"' > /tmp/pleac_stats_${i}
    cd /tmp/pleac
    rm -rf pleac
done
