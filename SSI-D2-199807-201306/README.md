Doublet 9813 in SSI.

## [data](data/): Seismic data downloading and preprocessing

### downloading

We use [SOD](http://www.seis.sc.edu/sod/) to download seismic data recorded at station `ARU` of eathquakes in `events.csv` from [IRIS](https://www.iris.edu/hq/) based on the recipe `recipe.xml`.

``` bash
# run the SOD recipe to download raw data inside seismograms-raw
$ sod -f recipe.xml
```
### preprocessing

We then perform some data preprocessing using [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) based on the script `preprocess.pl`.

``` bash
# the processed data is inside seismograms
$ perl preprocess.pl
```

## [scripts](scripts/): Scripts used to do calculation

### Forward calculation

- [cal-dt.pl](scripts/cal-dt.pl): calculate traveltime difference due to location difference

### Plotting

- [plot-seism.pl](scripts/plot-seism.pl): plot seismograms (Figs. 1g-1h)

### Dependent tools

- [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) : we use `saclst` command to find SAC header value
- [distaz](http://www.seis.sc.edu/software/distaz/) : calculate distance between station and event
- [TauP](http://www.seis.sc.edu/taup/index.html) : calculate predicted traveltime and slowness of PKIKP, PKiKP, and SKP
- [GMT](https://www.generic-mapping-tools.org/) : plot figures


## [docs](docs/): Calculation results

### travel time difference

Travel time difference of PKIKP, PKiKP, and SKP due to location difference of doublet 9813 at stations [ARU](ARU).

- `dd` : doublet depth offset
- `dt-dh` : travel time difference due to horizontal separation of doublet 9813
- `dt-dd` : travel time difference due to depth offset of doublet 9813
- `dt-all` : travel time difference due to horizontal and depth separation of doublet 9813


## [figs](figs/): Figures

- `seism-ARU-PKIKP-PKiKP.ps` : PKIKP-PKiKP waveforms at station ARU (Fig. 1g)
- `seism-ARU-SKP.ps` : SKP waveforms at station ARU (Fig. 1h)

