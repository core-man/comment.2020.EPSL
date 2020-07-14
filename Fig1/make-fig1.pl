#!/usr/bin/env perl
use strict;
use warnings;
# merge subfigs to Fig. 1 in Yao et al., 2020, EPSL.

# subfigs
my $subfig_dir1 = "../SSI-D1-199312-200309/figs";
my $subfig_dir2 = "../SSI-D2-199807-201306/figs";
my @subfigs = ("raypath", "dt-ARU",
                "seism-AAK-PKIKP-PKiKP", "seism-AAK-SKP",
                "seism-ARU-PKIKP-PKiKP", "seism-ARU-SKP",
                "seism-ARU-PKIKP-PKiKP", "seism-ARU-SKP");

# copy and convert ps to eps
for (my $i = 0; $i < @subfigs; $i++) {
    my $subfig;
    $subfig = "$subfig_dir1/$subfigs[$i]" if ($i < 6);
    $subfig = "$subfig_dir2/$subfigs[$i]" if ($i >= 6);

    `gmt psconvert -Te -A -P ${subfig}.ps`;
    `mv ${subfig}.eps $subfigs[$i]-${i}.eps`;
}


# GMT parameters
my $PS = "fig1.ps";
#my $J  = "X14c/12c";
#my $R  = "0/14/0/12";
my $J  = "X14c/15.5c";
my $R  = "0/14/0/15.5";

#my @widths = ("8.c","5.5c","7.0c","7.0c","7.0c","7.0c");
my @widths = ("8.c","5.5c","7.0c","7.0c","7.0c","7.0c","7.0c","7.0c");
#my @xs = ("-0.8c","7.5c","-1c","6.2c","-1c","6.2c");
my @xs = ("-0.8c","7.5c","-1c","6.2c","-1c","6.2c","-1c","6.2c");
#my @ys = ("15.8c","15.2c","11.6c","11.6c","8.1c","8.1c");
my @ys = ("15.8c","15.2c","11.6c","11.6c","8.1c","8.1c","4.6c","4.6c");


# begin plot
`gmt psxy -J$J -R$R -T -P -K > $PS`;

# union subfigures
for (my $i=0; $i<@subfigs; $i++) {
    print STDERR "$subfigs[$i]-${i}.eps\n";
    `gmt psimage -Dx$xs[$i]/$ys[$i]+w$widths[$i] $subfigs[$i]-${i}.eps -P -K -O >> $PS`;
}

# plot basemap
#`gmt psbasemap -J -R -BWSne -Bxa2f1 -Bya2f1 -X$xs[$#xs-1] -Y$ys[$#ys-1] -K -O >> $PS`;
`gmt psxy -J -R -X$xs[$#xs-1] -Y$ys[$#ys-1] -T -K -O >> $PS`;

# plot text
open(GMT, "| gmt pstext -R$R -J$J -F+f10,0,black+jLM -N -K -O >> $PS");
print GMT "0.3  15.5 (a)\n";
print GMT "13.35 15.5 (b)\n";
print GMT "0.3  9.8 (c)\n";
print GMT "7.5  9.8 (d)\n";
print GMT "0.3  6.3 (e)\n";
print GMT "7.5  6.3 (f)\n";
print GMT "0.3  2.8 (g)\n";
print GMT "7.5  2.8 (h)\n";
close(GMT);

# end plot
`gmt psxy -J$J -R$R -T -O >> $PS`;


`gmt psconvert -Tf -P -A $PS`;

unlink $PS;
`rm *.eps`;
`rm -rf gmt.*`;

