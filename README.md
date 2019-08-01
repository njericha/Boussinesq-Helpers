# Boussinesq-Helpers

## About
The MATLAB functions and scripts included in Boussinesq-Helpers were created in the 2019 summer term at the University of Waterloo by Nicholas Richardson. The intent of these functions is to be easy to use analysis tools for the data created by the boussinesq.F90 and related fortran code.

The set up of these functions allows for easy use once your files are orginized as follows. All the .m files should be in a single folder together, and any .dat or .ncf file should be organized in subfolders by n (the grid size used in the boussinesq.F90 simulations). These subfolders should be labled as 'n256' for example.

Each file contains a detailed description of what the function or script does. Below is an overview of the functions included in this repository.

## List of functions
mkfilepath - Helper to create a file path string corresponding to a given n, variable name, and possibly t.

datopen - Opens a regular .dat file and returns two lists of numbers, one for the times, and one for the value of the variable at those times.
datplot - Creates a timeplot of a regular .dat file.

spcopen - Opens an energy specrtum .dat file and returns two lists of numbers, one for the wave numbers, and one for the partial sum of energy of those wavenumbers.
spcplot - Plots the energy spectrum on a log-log scale.

ncfopen - Opens a .ncf file and returns a 3D array of the variable at a given time.
ncfplot - Creates a 2D slice (pcolor) plot of a variable at a given time.

slice3d - slices a 3D array into a 2D array on a given plane at a given depth.
fourierinterp - Uses a fourier transform method to interpolate a 2D array of values.

kolwavenum - Calculates the Kolmogrorov Dissipation Wavenumber for a given energy spectrum.

getridx.m - Helper to load (or calculate if needed) indexes of 3D wavenumbers in MATLAB's fft format
rsum - Uses getridx to sphericaly sum over a constant radius values in a 3D array

tofmaxval - Finds the time of the max value in a list of numbers.

## List of scripts
spccomp - Uses spcplot to graph the energy spectrum for multiple n's.
subplotmtx - Uses ncfplot to create a 'subplot matrix' of pcolor plots for multiple n's.

penstrophy - Calculates the partial and total potential enstrophy and plots it.
pvorticity - Calculates the potential vorticity spectrum and dissipation wavenumbers.
pvcomp - Mini script to take a time average of the potential vorticity spectrum.
pvscript - Old version of penstrophy.
