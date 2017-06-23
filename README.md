# Generic ROC curve plotter

An application to generate a ROC curve given signal and background samples.
The user is expected to provide:
1. The locations of the signal and background samples. They should take the form of a 'flat' `TTree` inside a `TFile`. Just providing the filenames should suffice in 99% of cases.
1. A cut string with `{}` in place for the parameter of interest (POI).
1. Upper and lower limits on the POI and the number of points to plot.

## Dependencies

- Boost
- ROOT
- My [`common`](https://github.com/abmorris/common) libs (included as a submodule)

## Building

Make sure to do `git clone --recursive` to checkout the submodule. Then just type `make` to install.

## Running

Calling `bin/ROCcurve --help` should provide a description of the command-line options.
At a minimum you should specify:

- `--expr`: the cut expression. `{}` will be substituted with the POI value
- `--Sfile`: the signal ntuple
- `--Bfile`: the background ntuple
- `--varmax`: the upper limit on the POI
- `--varmin`: the lower limit on the POI

