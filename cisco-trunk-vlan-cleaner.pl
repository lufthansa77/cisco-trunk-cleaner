#!/usr/bin/env perl
# trunk vlan comparsion cleaner

use strict;
use warnings;

use Data::Dump qw/pp/;

my $port1 = "
 switchport trunk allowed vlan 82,92,97,104,105,108,151,157,201,218,222,247,260
 switchport trunk allowed vlan add 263,268,326,402-404,407,408,457,465,513
 switchport trunk allowed vlan add 515-517,534,553-556,558,560,564-566,577,626
 switchport trunk allowed vlan add 631,645,669,720,733,750,804,814-819,849,856
 switchport trunk allowed vlan add 878,903,910,916,921,943,958,1071,1101,1103
 switchport trunk allowed vlan add 1119,1120,1125,1129,1146,1148,1157,1176,1181
 switchport trunk allowed vlan add 1182,1185,1186,1189,1200,1245,1250,1254,1269
 switchport trunk allowed vlan add 1270,1742,1743,2259,2261,2262,2267,2278,2285
 switchport trunk allowed vlan add 2292,2304,2305,2314,2331,2341-2348,2350-2352
 switchport trunk allowed vlan add 2356-2358,2369,2377,2504-2507,2509,2512,2514
 switchport trunk allowed vlan add 2515,2536-2539,2575-2580,2600,2602,2604,2605
 switchport trunk allowed vlan add 2607,2608,2619,2621,2634,2635,2637-2639
 switchport trunk allowed vlan add 2641-2645,2647,2665,2667,2668,2672,2673,2687
 switchport trunk allowed vlan add 2688,2703-2705,2750,2761,2763,2767,2768,2780
 switchport trunk allowed vlan add 3003,3006,3017,3029,3032,3045,3046,3055,3069
 switchport trunk allowed vlan add 3075,3079-3081,3085,3096,3111,3122,3142,3151
 switchport trunk allowed vlan add 3204,3233,3274,3280,3281,3284-3288,3294,3328
 switchport trunk allowed vlan add 3341,3342,3422,3434,3441,3458,3460,3491,3493
 switchport trunk allowed vlan add 3494,3550,3567,3570,3594,3599,3610,3699,3701
 switchport trunk allowed vlan add 3721,3731,3821,3822,3828
";
my $port2 = "
 switchport trunk allowed vlan 82,83,92,97,104,105,108,151,157,201,218,222,247
 switchport trunk allowed vlan add 260,263,268,316,326,402-404,407,408,457
 switchport trunk allowed vlan add 515-517,534,551,553-556,558,560,561,564-566
 switchport trunk allowed vlan add 577,626,631,645,720,732,733,750,777,804
 switchport trunk allowed vlan add 814-819,849,856,877,878,896,903,910,916,943
 switchport trunk allowed vlan add 958,1071,1101,1103,1119,1120,1125,1129,1146
 switchport trunk allowed vlan add 1148,1157,1176,1181,1182,1185,1186,1189,1200
 switchport trunk allowed vlan add 1245,1250,1254,1269,1270,1742,1743,2259,2261
 switchport trunk allowed vlan add 2262,2267,2278,2285,2292,2304,2305,2314,2331
 switchport trunk allowed vlan add 2341-2348,2350-2352,2356-2358,2369,2377,2382
 switchport trunk allowed vlan add 2385,2504-2507,2509,2512,2514,2515,2536-2539
 switchport trunk allowed vlan add 2575-2580,2600,2602,2604,2605,2607,2608,2619
 switchport trunk allowed vlan add 2621,2634,2635,2637-2639,2641-2645,2647,2665
 switchport trunk allowed vlan add 2667,2668,2672,2673,2687,2688,2703-2705,2750
 switchport trunk allowed vlan add 2761,2763,2767,2768,2780,2798,3003,3004,3006
 switchport trunk allowed vlan add 3017,3029,3032,3045,3046,3055,3075,3079-3081
 switchport trunk allowed vlan add 3085,3096,3111,3122,3142,3151,3233,3341,3342
 switchport trunk allowed vlan add 3434,3441,3458,3460,3493,3494,3550,3570,3594
 switchport trunk allowed vlan add 3599,3610,3699,3701,3721,3731,3821,3822,3828
";

my @array1 = ();
my @array2 = ();

my @lines = split /\n/, $port1;
foreach my $line (@lines) {
    $line =~ s/[ ]|[ ]+//g;    # remove spaces
    $line =~ s/[a-z]+//gi;     # remove charates
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
    $line =~ s/[ ]|[ ]+//g;    # remove spaces
    $line =~ s/[a-z]+//gi;     # remove charates
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
@isect = sort { $a <=> $b } @isect;
print "\nIntersect Array = @isect\n";
@diff = sort { $a <=> $b } @diff;
print "\nDiff Array = @diff\n\n";

foreach my $vlan ( sort { $a <=> $b } @diff ) {
    print "switchport trunk allowed vlan remove $vlan\n";
}
print "\n";

exit 0;
__END__


