
## Scripts

Calculation :

- cal-dt.pl : calculate traveltime difference due to location difference


Plotting :

- plot-raypath.pl : plot raypaths of PKIKP, PKiKP and SKP (Fig. 1a)
- plot-dt.pl      : plot travel time difference due to doublet depth difference (Fig. 1b)
- plot-seism.pl   : plot seismograms (Figs. 1c-1f)
- make-fig1.pl    : unify all the subfigures (Fig. 1)


## Dependent tools

- [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) : we use `saclst` command to find SAC header value

- [distaz](http://www.seis.sc.edu/software/distaz/) : calculate distance between station and event

- [TauP](http://www.seis.sc.edu/taup/index.html) : calculate predicted traveltime and slowness of PKIKP, PKiKP, and SKP

- [GMT](https://www.generic-mapping-tools.org/) : plot figures

