#!/usr/bin/env python

import sys
import os

known_langs = {
    'perl': 'Perl',
    'groovy': 'Groovy',
    'python': 'Python',
    'ruby': 'Ruby',
    'ocaml': 'Objective CAML',
    'guile': 'Guile',
    'tcl': 'Tcl',
    'php': 'PHP',
    'rexx': 'REXX',
    'pike': 'Pike',
    'merd': 'Merd',
    'ada': 'Ada',
    'haskell': 'Haskell',
    'haskell-on-steroids': 'Haskell on Steroids',
    'java': 'Java',
    'cposix': 'C/POSIX/GNU',
    'pliant': 'Pliant',
    'commonlisp': 'Common Lisp',
    'c++': 'C++/STL/BOOST',
    'smalltalk': 'Smalltalk',
    'forth': 'Forth',
    'erlang': 'Erlang',
    'R': 'R',
    'masd': 'MASD',
    'nasm': 'NASM',
}

if len(sys.argv) < 2:
    print 'Usage: %s <lang> [<lang> ...]'
    sys.exit(1)

if sys.argv[1] == 'all':
    langs = known_langs.keys()
else:
    langs = sys.argv[1:]

for lang in langs:
    f = open('pleac_%s.txt' % lang, 'w')
    heading = ' PLEAC: %s ' % known_langs.get(lang, lang)
    f.write('=' * len(heading) + '\n')
    f.write(heading + '\n')
    f.write('=' * len(heading) + '\n\n')
    f.write(open('header.txt').read()
            % {'language': known_langs.get(lang, lang)})
    f.write('\n\n.. contents::\n\n')
    f.close()

    for i in xrange(1, 21):
        os.system('./pleac2rst.py %s %d >> pleac_%s.txt' % (lang, i, lang))

    os.system('rst2latex --use-latex-toc pleac_%s.txt > pleac_%s.tex' % (lang, lang))
    os.system('pdflatex pleac_%s.tex' % lang)
    os.system('pdflatex pleac_%s.tex' % lang)
