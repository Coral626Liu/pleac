#!/usr/bin/env python

import re
import sys
import urllib
from HTMLParser import HTMLParser

# Download chapters via HTTP?
online_mode = False

# If online_mode is True, the base URL to use:
base_url = 'http://pleac.sourceforge.net'

# If online_mode is False, the base local directory to use:
base_dir = '..'

# Names of PLEAC chapters, in the order they appear:
pleac_chaps = [
    'strings',
    'numbers',
    'datesandtimes',
    'arrays',
    'hashes',
    'patternmatching',
    'fileaccess',
    'filecontents',
    'directories',
    'subroutines',
    'referencesandrecords',
    'packagesetc',
    'classesetc',
    'dbaccess',
    'userinterfaces',
    'processmanagementetc',
    'sockets',
    'internetservices',
    'cgiprogramming',
    'webautomation',
]

def pleac_url(lang, chap):
    return '%s/pleac_%s/%s.html' % (base_url, lang, chap)

def pleac_file(lang, chap):
    return '%s/pleac_%s/%s.html' % (base_dir, lang, chap)

def get_chap(lang, chap, online=False):
    try:
        chap = pleac_chaps[int(chap) - 1]
    except ValueError:
        pass
    if online:
        return urllib.urlopen(pleac_url(lang, chap)).read()
    else:
        return open(pleac_file(lang, chap)).read()

def normalize_dashes(s):
    return re.sub('----------+', '-' * 70, s)

class PLEACParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.in_named_anchor = False
        self.in_section_heading = False
        self.seen_section_heading = False
        self.seen_footer = False
        self.seen_solution = True

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            for (key, value) in attrs:
                if key == 'name':
                    self.in_named_anchor = True
                    if not value.startswith('AEN'):
                        self.in_section_heading = True
                        self.seen_section_heading = True
        elif tag == 'div':
            for (key, value) in attrs:
                if key == 'class':
                    if value == 'NAVFOOTER':
                        self.seen_footer = True

    def handle_endtag(self, tag):
        if tag == 'a':
            self.in_named_anchor = False
            self.in_section_heading = False

    def handle_data(self, data):
        if self.in_named_anchor:
            if self.in_section_heading:
                sys.stdout.write('\n.. raw:: latex\n\n    \\newpage\n\n\n')
                data = re.sub(r'^\d+\. ', '', data)
                sys.stdout.write('-' * len(data) + '\n')
                sys.stdout.write(data + '\n')
                sys.stdout.write('-' * len(data) + '\n')
            else:
                if self.seen_section_heading and not self.seen_solution:
                    sys.stdout.write('To be completed.')
                self.seen_solution = False
                if data != 'Introduction':
                    sys.stdout.write('\n\n')
                    sys.stdout.write(data + '\n')
                    sys.stdout.write('=' * len(data) + '\n')
                sys.stdout.write('\n::\n\n    ')
        elif self.seen_section_heading and not self.seen_footer:
            self.seen_solution = True
            sys.stdout.write(normalize_dashes(data).replace('\n', '\n    '))
        elif self.seen_footer and not self.seen_solution:
            sys.stdout.write('To be completed.')
            self.seen_solution = True

    def handle_entityref(self, data):
        if data != 'nbsp':
            sys.stdout.write(self.unescape('&%s;' % data))

if len(sys.argv) < 3:
    print 'Usage: %s <lang> <chap>'
    sys.exit(1)

p = PLEACParser()
p.feed(get_chap(sys.argv[1], sys.argv[2], online_mode))
sys.stdout.write('\n\n')
