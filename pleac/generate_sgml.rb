#!/usr/bin/ruby
#
#        *  PLEAC - Programming Language Examples Alike Cookbook  *
#
#                        http://pleac.sf.net/
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

version = 2

if ARGV.to_s =~ /-h/ || !ARGV[0] || !ARGV[1] || !ARGV[2] || ARGV[3]
    puts 'PLEAC Project: http://pleac.sf.net/'
    puts "usage: #$0 <skeleton_file> <implementation_file> <output_file>"
    exit -1
end


skel_contents = File.open(ARGV[0]).read
impl_contents = File.open(ARGV[1]).readlines.push("@@@")

current_key = nil
current_subst = []
for i in impl_contents
    if i =~ /^@@@(.*)/
	new_key = $1
	if current_subst.size > 0
	    while current_subst.last =~ /^$/
		current_subst.pop
	    end
	    if current_subst[-1]
		current_subst[-1].chop!
	    end
	    if current_key
		skel_contents.gsub!(Regexp.escape("PLEAC:#{current_key}:CAELP"), current_subst.to_s)
	    end
	    current_subst = []
	end
	current_key = new_key
    else
	current_subst.push(i.gsub('<', '&lt;').gsub(/\\/, '\\\\\\'))  # escape for SGML, escape \ for further gsub
    end
end

skel_contents.gsub!("PLEAC:.*:CAELP", "")

File.open(ARGV[2], 'w').write(skel_contents)


