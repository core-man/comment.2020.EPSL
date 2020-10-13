
Seismic data downloading and preprocessing

## downloading

We use [SOD](http://www.seis.sc.edu/sod/) to download seismic data recorded at stations `ARU` and `AAK` of eathquakes in `events.csv` from [IRIS](https://www.iris.edu/hq/) based on the recipe [recipe.xml](recipe.xml)

``` bash
# run the SOD recipe to download raw data inside seismograms-raw
$ sod -f recipe.xml
```

## preprocessing

We then perform some data preprocessing using [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) based on the script [preprocess.pl](preprocess.pl).

``` bash
# the processed data is inside seismograms
$ perl preprocess.pl
```

