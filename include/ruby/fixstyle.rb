# fixstyle - switch first set of <DATA> strings to second set
#   usage: $0 [-v] [files ...]
#   -v = verbose  prints "a->b in file line N" for every change.
# If no filenames are given, than the script runs as simple filter,
# else the files are edited in place, and a safety copy
# with the exentions ".orig" is created

# Regular expressions are objects in ruby, we have control
# when we compile them, so we don't need the eval hack
# from the perl solution.
# The changer class encapsulates the regular expression
# and its substitution string
class Changer
    
    def initialize(regex, subst)
        @regex = Regexp.compile(regex)
        @subst = subst
    end
    
    def change(string)
        changed = string.gsub!(@regex, @subst)
        if changed && $verbose
            $stderr.puts("#{@regex.source} changed to #{@subst} at #{$FILENAME} line #{$.}")
        end
    end
    
end

# get the lines from the Data section at the end of the file
# and put them in the list of Changer objects
def get_subs_from_end()
    changelist = []
    DATA.each do |line|
        line.chomp!
        (pat, subst) = line.split(/\s*=>\s*/)
        if pat && subst
            changelist.push(Changer.new(pat, subst))
        end
    end
    changelist
end

changelist = get_subs_from_end()

if ARGV && ARGV[0] == "-v"
    ARGV.shift
    $verbose = true
else
    $verbose = false
end

if ARGV.length > 0
    $-i = ".orig"     # enables in-place edit mode
elsif test(?e, $stdin)
    $stderr.puts("#{$0}:Reading from stdin")
end

while line = gets()
    for changer in changelist
        changer.change(line)
    end
    puts(line)
end

__END__

# analysed  => analyzed
# build-in  => builtin
# chastized => chatis
# commandline     => command-line
# de-allocate     => deallocate
# dropin          => drop-in
# hardcode        => hard-code
# meta-data       => metadata
# multicharacter  => multi-character
# multiway        => multi-way
# non-empty       => nonempty
# non-profit      => nonprofit
# non-trappable   => nontrappable
# pre-define      => predefine
# preextend       => pre-extend
# re-compiling    => recompiling
# reenter         => re-enter
# turnkey         => turn-key
