#!/usr/bin/env perl
use strict;
use warnings;

# subfigs
my $subfig_dir = "../figs";
my @subfigs = ("raypath", "dt-ARU",
                "seism-AAK-PKIKP-PKiKP", "seism-AAK-SKP",
                "seism-ARU-PKIKP-PKiKP", "seism-ARU-SKP");
$_ = "$subfig_dir/$_" foreach (@subfigs);

# convert ps to eps
`gmt psconvert -Te -A -P ${_}.ps` foreach (@subfigs);

# GMT parameters
my $PS = "../figs/fig1.ps";
my $J  = "X14c/12c";
my $R  = "0/14/0/12";

#my @widths = ("8.c","5.5c","6.5c","6.5c","6.5c","6.5c");
my @widths = ("8.c","5.5c","7.0c","7.0c","7.0c","7.0c");
#my @xs = ("-0.8c","8.0c","-1c","5.7c","-1c","5.7c");
my @xs = ("-0.8c","7.5c","-1c","6.2c","-1c","6.2c");
my @ys = ("15.8c","15.2c","11.6c","11.6c","8.1c","8.1c");


# begin plot
`gmt psxy -J$J -R$R -T -P -K > $PS`;

# union subfigures
for (my $i=0; $i<@subfigs; $i++) {
    `gmt psimage -Dx$xs[$i]/$ys[$i]+w$widths[$i] $subfigs[$i].eps -P -K -O >> $PS`;
}

# plot basemap
#`gmt psbasemap -J -R -BWSne -Bxa2f1 -Bya2f1 -X$xs[$#xs-1] -Y$ys[$#ys-1] -K -O >> $PS`;
`gmt psxy -J -R -X$xs[$#xs-1] -Y$ys[$#ys-1] -T -K -O >> $PS`;

# plot text
open(GMT, "| gmt pstext -R$R -J$J -F+f10,0,black+jLM -N -K -O >> $PS");
print GMT "0.3  12. (a)\n";
#print GMT "7.95  9.4 (b)\n";
print GMT "13.35 12. (b)\n";
print GMT "0.3  6.3 (c)\n";
print GMT "7.5  6.3 (d)\n";
print GMT "0.3  2.8 (e)\n";
print GMT "7.5  2.8 (f)\n";
close(GMT);

# end plot
`gmt psxy -J$J -R$R -T -O >> $PS`;


`gmt psconvert -Tf -P -A $PS`;

unlink "${_}.eps" foreach (@subfigs);
`rm -rf gmt.*`;

