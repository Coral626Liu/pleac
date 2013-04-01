#!/usr/bin/perl

sub cat_ { my @l = map { my $F; open($F, '<', $_) ? <$F> : () } @_; wantarray() ? @l : join '', @l }
sub output { my $f = shift; open(my $F, ">$f") or die "output in file $f failed: $!\n"; print $F $_ foreach @_; 1 }
sub chomp_ { my @l = @_; chomp @l; wantarray() ? @l : $l[0] }

foreach my $i (0..89) {
    foreach my $l (cat_("/tmp/pleac_stats_$i")) {
        $l =~ /(\S+) (\S+)/ and $impl{$1}{$i} = $2;
    }
}

my @impls = qw/groovy python ruby guile merd ada tcl ocaml haskell pike java pliant commonlisp c++ forth erlang php R masd nasm rexx cposix/;

foreach my $i (0..89) {
    my $out = chomp_(`date --date="$i month ago" +%y/%m`) . " ";
    foreach my $imp (@impls) {
        $out{$imp} .= $out . ($impl{$imp}{$i} || 0) . "\n";
    }
}

foreach my $imp (@impls) {
    output("pleac_stats_$imp", $out{$imp}, "01/05 0");
}

