#!/usr/bin/env python
'''
Guess and Convert an input file to utf8
'''

DATE = "Saturday, April  6 2013"
AUTHOR = "Yagnesh Raghava Yakkala"
LICENSE ="GPL v3 or later"

import os
import chardet
import shutil
import codecs

def conv2utf8(input_file,target_file,source_encoding):
    with codecs.open(input_file,'r',source_encoding) as sf:
        cont = sf.read()
        sf.close()
        with codecs.open(target_file,'w','utf-8') as tf:
            tf.write(cont)

def arg_parse(no_backup=False,files=None):
    backup_ext = ".bkp"
    for f in files:
        if not no_backup:
            shutil.copy2(f, f + backup_ext )
        char_en = chardet.detect(open(f).read())
        print(f + ": " + char_en['encoding'])
        conv2utf8(f, f, char_en['encoding'])

def main(args=None):
    import argparse
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        description=__doc__)
    parser.add_argument('-nb','--no-backup', action='store_true')
    parser.add_argument('files', nargs='+', help='file(s) to convert.')
    arg_parse(**vars(parser.parse_args(args)))

if __name__ == '__main__':
    main()
