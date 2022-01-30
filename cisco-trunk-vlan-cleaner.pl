#!/usr/bin/env perl
# trunk vlan comparsion cleaner
#
use strict;
use warnings;

use Data::Dump qw/pp/;

my $port1 = "2,4,5,10-20,50
,445";
my $port2 = "2,5,10-19,50,51";

my @array1 = ();
my @array2 = ();

my @lines = split /\n/, $port1;
foreach my $line (@lines) {
    my @arry = split( /,/, $line );
    foreach my $s (@arry) {
        if ( $s =~ /^\d+$/ ) {
            push( @array1, $s );
        }
        if ( $s =~ /^(\d+)-(\d+)$/ ) {
            for ( my $i = $1 ; $i <= $2 ; $i++ ) {
                push( @array1, $i );
            }
        }
    }
}

@lines = split /\n/, $port2;
foreach my $line (@lines) {
    my @arry = split( /,/, $line );
    foreach my $s (@arry) {
        if ( $s =~ /^\d+$/ ) {
            push( @array2, $s );
        }
        if ( $s =~ /^(\d+)-(\d+)$/ ) {
            for ( my $i = $1 ; $i <= $2 ; $i++ ) {
                push( @array2, $i );
            }
        }
    }
}

my @isect = ();
my @diff  = ();
my %count = ();

foreach my $item ( @array1, @array2 ) { $count{$item}++; }

foreach my $item ( keys %count ) {
    if ( $count{$item} == 2 ) {
        push @isect, $item;
    } else {
        push @diff, $item;
    }
}

print "\nA Array = @array1\n";
print "\nB Array = @array2\n";
print "\nIntersect Array = @isect\n";
print "\nDiff Array = @diff\n\n";

foreach my $vlan ( sort { $a <=> $b } @diff) {
    print "switchport trunk allowed vlan remove $vlan\n";
}
print "\n";

exit 0;
__END__


