#!/usr/bin/ruby
#
#        *  PLEAC - Programming Language Examples Alike Cookbook  *
#
#                      http://pleac.sourceforge.net/
#
#
# Copyright (c) 2001 Guillaume Cottenceau (gc@mandraknospamesoft.com)
#
# This software may be freely redistributed under the terms of the GNU
# public license.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

version = 1

if ARGV.to_s =~ /-h/ || !ARGV[1] || !ARGV[2] || ARGV[3]
    puts 'PLEAC Project: http://pleac.sourceforge.net/'
    puts "usage: #$0 <toc_file> <implementation_file> <skeleton>"
    exit -1
end


chapters = {                                     
    "Strings", 1,
    "Numbers", 2,
    "Dates and Times", 3,
    "Arrays", 4,
    "Hashes", 5,
    "Pattern Matching", 6,
    "File Access", 7,
    "File Contents", 8,
    "Directories", 9,
    "Subroutines", 10,
    "References and Records", 11,
    "Packages, Libraries, and Modules", 12,
    "Classes, Objects, and Ties", 13,
    "Database Access", 14,
    "User Interfaces", 15,
    "Process Management and Communication", 16,
    "Sockets", 17,
    "Internet Services", 18,
    "CGI Programming", 19,
    "Web Automation", 20,
}

toc_contents = File.open(ARGV[0]).read
impl_contents = File.open(ARGV[1]).readlines
skel_contents = File.open(ARGV[2]).read

chapters.each { |k,v|
    actual = 0
    for i in impl_contents
	if i =~ /^.*@@PLEAC@@_([^<]+).*$/ || i =~ /^.*\^\^PLEAC\^\^_([^<]+).*$/
	   actual += 1 if $1.to_i == v
	end
    end
    total = 0 
    for i in skel_contents
	if i =~ /PLEAC:(.*):CAELP/
	   total += 1 if $1.to_i == v
	end
    end
    percentage = Float(100*actual)/total
    toc_contents.sub!(">#{k}</A", sprintf ">#{k}</a>(%.1f%s)</br", percentage, "%")
}

File.open(ARGV[0], 'w').write(toc_contents)
