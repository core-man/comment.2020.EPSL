#!/usr/bin/perl
use strict;
use warnings;
# plot raypath

my $PS = "../figs/raypath.ps";
my $J  = "Pa3.5c/80";
#my $J  = "Pa4c/80";
my $R  = "-10/170/0/6371";

=pod
my $J1  = "Pa100c/80";
#my $R1  = "-0.05/0.1/0/6371";
my $R1  = "-0.3/0.5/0/6371";

my $J2  = "Pa100c/80.0133";
my $R2  = "-0.5/0.8/0/6371";
=cut

my ($col1, $col2, $col3) = ("dodgerblue1", "black", "brown");

# GMT default setting
`gmt gmtset MAP_FRAME_PEN 0.5p`;
`gmt gmtset MAP_TICK_LENGTH_PRIMARY 1.5p`;
`gmt gmtset MAP_LABEL_OFFSET 2p`;
`gmt gmtset FONT_ANNOT_PRIMARY 6p,Helvetica`;
`gmt gmtset FONT_LABEL 8p,Helvetica`;



# begin plotting
`gmt psxy -J$J -R$R -P -X10c -Y10c -T -K > $PS`;


# plot boundaries
`gmt psbasemap -J -R -Byg6371 -Bs -K -O >> $PS`;      # plot free-surface
`gmt psbasemap -J -R -Byg6371+3480 -Bs -K -O >> $PS`; # plot CMB
`gmt psbasemap -J -R -Byg6371+1221 -Bs -K -O >> $PS`; # plot ICB

# plot horizontal line
open(GMT, "| gmt psxy -J -R -K -O >> $PS");
print GMT "-10 6371\n";
print GMT "-10 0\n";
print GMT "170 6371\n";
close(GMT);

# calculate and plot raypath
`taup_path -mod iasp91 -ph PKIKP -h 33 -deg 132 -o ../docs/PKIKP.raypath`;
`taup_path -mod iasp91 -ph PKiKP -h 33 -deg 132 -o ../docs/PKiKP.raypath`;
#`taup_path -mod iasp91 -ph SKP -h 33 -deg 132 -o ../docs/SKP.raypath`;
`gmt psxy ../docs/PKIKP.raypath.gmt -J -R -W1p,$col1 -K -O >> $PS`;
`gmt psxy ../docs/PKiKP.raypath.gmt -J -R -W0.7p,$col3 -K -O >> $PS`;
`gmt psxy ../docs/SKP.raypath.gmt -J -R -W1p,$col2 -K -O >> $PS`;

# plot station and event
`echo 0 6341 0.2c a | gmt psxy -J -R -S -Gred -N -K -O >> $PS`;
`echo 130 6671 0.2c i | gmt psxy -J -R -S -Gblack -N -K -O >> $PS`;

# plot text
#`echo 155 6671 -75 Surface | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;
#`echo 155 3780 -75 CMB | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;
#`echo 145 1521 -75 ICB | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;
`echo 80 500 0 IC | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;
`echo 155 2221 0 OC | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;
`echo 162 4950 0 Mantle | gmt pstext -J -R -F+f6+a -N -K -O >> $PS`;

`echo 130 2821 30 "PKIKP\(DF\)" | gmt pstext -J -R -F+f6,$col1+a -N -K -O >> $PS`;
#`echo 100 2421 30 PKiKP | gmt pstext -J -R -F+f5.5,blue+a -N -K -O >> $PS`;
`echo 90 4650 0 "PKiKP\(CD\)" | gmt pstext -J -R -F+f5.5,$col3+a -N -K -O >> $PS`;
`echo 60 2521 18 SKP | gmt pstext -J -R -F+f6,$col2+a -N -K -O >> $PS`;


# plot zoom-in raypath
#`gmt psxy -J$J -R$R -Y1c -T -K -O >> $PS`;
`gmt psxy -J$J -R$R -Y-0.1c -X-0.1c -T -K -O >> $PS`;

#my $J2 = "X8.5c/4c";
my $J2 = "X8.5c/5.1c";
my $R2 = "0/2.1/0/2.1";
my @sx = (1.1, 1.2);
my @sy = (1.0, 1.5);

# plot box
#open(GMT, "| gmt psxy -R$R2 -J$J2 -Gwhite -W0.3p,black -K -O >> $PS");
#print GMT "0 0\n0 2.1\n2.1 2.1\n2.1 0\n0 0\n";
#close(GMT);
open(GMT, "| gmt psxy -R$R2 -J$J2 -W0.5p,black -N -K -O >> $PS");
print GMT "0. 0\n0. 2.\n2.1 2.\n2.1 0\n0. 0\n";
close(GMT);

#`gmt psbasemap -J$J2 -R$R2 -Bxa1f0.5 -Bya1f0.5 -BWSne -K -O >> $PS`;
# plot surface
#open(GMT, "| gmt psxy -R -J -W1.5p,black -N -K -O >> $PS");
#print GMT "0.5 1.8\n2 1.8\n";
#close(GMT);

# plot PKP raypath
open(GMT, "| gmt psxy -R -J -W0.5p,$col1 -K -O >> $PS");
print GMT "$sx[0] $sy[0]\n 1.15 0.\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W0.5p,$col1 -K -O >> $PS");
print GMT "$sx[1] $sy[1]\n 1.29 0.\n";
close(GMT);
`echo 1.08 0.34 -85 "PKIKP\(DF\)" | gmt pstext -J -R -F+f8,$col1+a -N -K -O >> $PS`;

# plot SKP raypath
open(GMT, "| gmt psxy -R -J -W0.5p,$col2 -K -O >> $PS");
print GMT "$sx[0] $sy[0]\n 1.315 0.\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W0.5p,$col2 -K -O >> $PS");
print GMT "$sx[1] $sy[1]\n 1.54 0.\n";
close(GMT);
`echo 1.52 0.3 -70 SKP | gmt pstext -J -R -F+f8,$col2+a -N -K -O >> $PS`;

# plot source depth
open(GMT, "| gmt psxy -R -J -W0.5p -K -O >> $PS");
print GMT "1.0 $sy[0]\n 1.05 $sy[0]\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W0.5p -K -O >> $PS");
print GMT "1.0 $sy[1]\n 1.05 $sy[1]\n";
close(GMT);
`echo 1.025 $sy[0] 1.025 $sy[1] | gmt psxy -J -R -Sv0.15c+s+b+e -W0.5p -Gblack -N -O -K >> $PS`;
`echo 0.99 1.25 90 0.7 km | gmt pstext -J -R -F+f7,black+a -N -K -O >> $PS`;

# plot vertical line & bold rays
open(GMT, "| gmt psxy -R -J -W0.5p,$col2,2_1_2_1:0p -K -O >> $PS");
print GMT "$sx[0] $sy[0]\n1.28 1.122\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W1.3p,$col2 -K -O >> $PS");
print GMT "$sx[1] $sy[1]\n1.284 1.122\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W0.5p,$col2 -K -O >> $PS");
print GMT "1.265 1.115\n1.275 1.075\n1.29 1.085\n";
close(GMT);
`echo 1.305 1.25 20 S | gmt pstext -J -R -F+f10,$col2+a -N -K -O >> $PS`;

open(GMT, "| gmt psxy -R -J -W0.5p,$col1,2_1_2_1:3.0p -K -O >> $PS");
print GMT "$sx[0] $sy[0]\n1.22 1.02\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W1.3p,$col1 -K -O >> $PS");
print GMT "$sx[1] $sy[1]\n1.228 1.02\n";
close(GMT);
open(GMT, "| gmt psxy -R -J -W0.5p,$col1, -K -O >> $PS");
print GMT "1.207 1.02\n1.21 0.98\n1.23 0.983\n";
close(GMT);
`echo 1.17 1.2 5 P | gmt pstext -J -R -F+f10,$col1+a -N -K -O >> $PS`;


# plot source
`echo $sx[0] $sy[0] 0.3c a | gmt psxy -J$J2 -R$R2 -S -Gred -N -K -O >> $PS`;
`echo $sx[1] $sy[1] 0.3c a | gmt psxy -J -R -S -Gblue -N -K -O >> $PS`;
`echo 0.97  0.9 0 2003 | gmt pstext -J -R -F+f12,red+a -N -K -O >> $PS`;
`echo 1.2  1.65 0 1993 | gmt pstext -J -R -F+f12,blue+a -N -K -O >> $PS`;


# plot dt
`echo 1.5 1.345 0 \104 | gmt pstext -J -R -F+f10,12,black+a+jLM -N -K -O >> $PS`;
`echo 1.57 1.35 0 "= 132\260 \(ARU\)" | gmt pstext -J -R -F+f10,black+a+jLM -N -K -O >> $PS`;
`echo 1.5 1.2 0 "dt\(PKIKP\) = -0.106 s" | gmt pstext -J -R -F+f7,black+a+jLM -N -K -O >> $PS`;
`echo 1.5 1.1 0 "dt\(PKiKP\) = -0.106 s" | gmt pstext -J -R -F+f7,black+a+jLM -N -K -O >> $PS`;
`echo 1.5 1.0 0 "dt\(SKP\)    = -0.185 s" | gmt pstext -J -R -F+f7,black+a+jLM -N -K -O >> $PS`;

`echo 0.05 1.35 0 "Depth correction:" | gmt pstext -J -R -F+f10,black+a+jLM -N -K -O >> $PS`;
`echo 0.05 1.2 0 "dt\(phase\) = t\(2003\) - t\(1993\)" | gmt pstext -J -R -F+f7,black+a+jLM -N -K -O >> $PS`;


# plot arrow
`echo 0.5 0.5 -90 0.63 | gmt psxy -J -R -Sv0.12c+e -W0.5p,$col3 -G$col3 -N -O -K >> $PS`;

# end plot
`gmt psxy -J -R -T -O >> $PS`;


#`gmt psconvert -Tf -P -A $PS`;
`rm gmt.*`;

