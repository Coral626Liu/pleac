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

version = 3

if ARGV.to_s =~ /-h/ || !ARGV[1] || ARGV[2]
    puts 'PLEAC Project: http://pleac.sourceforge.net/'
    puts "usage: #$0 <html_file> <implementation_file>"
    exit -1
end


skel_contents = File.open(ARGV[0]).read
impl_contents = File.open(ARGV[1]).readlines.push("@@PLEAC@@_FAKE")

current_key = nil
current_subst = []
for i in impl_contents
    if i =~ /^.*@@PLEAC@@_([^<\s]+).*$/ || i =~ /^.*\^\^PLEAC\^\^_([^<\s]+).*$/
	new_key = $1
	if current_subst.size > 0
	    while current_subst.last =~ /^$/
		current_subst.pop
	    end
	    if current_subst[-1]
		current_subst[-1].chop!
	    end
	    if current_key
		final_subst = [ "<font color=\"#f5deb3\" size=\"+2\">", current_subst, "PLEAC:#{current_key}:CAELP" ].flatten.to_s
		if current_key == "NAME" || current_key == "WEB"
		    final_subst.gsub!("<[^>]+>", "")
		end
		final_subst.gsub!(/.*@@SKIP@@\s*(.*)\s*@@SKIP@@.*/) { $1 }
		final_subst.gsub!(/.*@@SKIP@@\s*/, '')
		skel_contents.gsub!(Regexp.escape("PLEAC:#{current_key}:CAELP"), final_subst)
	    end
	    current_subst = [ i.gsub(/^[^<]+\n/, '').gsub("[^<]*(<[^>]*>)[^<]*") { $1 } ]  # keep only HTML stuff of keyword line
	end
	current_key = new_key
    else
	current_subst.push(i.gsub(/\\/, '\\\\\\'))  # escape for SGML, escape \ for further gsub
    end
end

skel_contents.gsub!("PLEAC:.*:CAELP", "")
skel_contents.gsub!("BGCOLOR.*", "bgcolor=\"#2f4f4f\"")
skel_contents.gsub!("><BODY.*", "><BODY TEXT=\"#cecece\" BGCOLOR=\"#4f6f6f\" LINK=\"#f5deb3\" VLINK=\"#d5ae83\"")

File.open(ARGV[0], 'w').write(skel_contents)


