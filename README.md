# Boussinesq-Helpers

## About
The MATLAB functions and scripts included in Boussinesq-Helpers were created in the 2019 summer term at the University of Waterloo by Nicholas Richardson. The intent of these functions is to be easy to use analysis tools for the data created by the boussinesq.F90 and related fortran code.

The set up of these functions allows for easy use once your files are orginized as follows. All the .m files should be in a single folder together, and any .dat or .ncf file should be organized in subfolders by n (the grid size used in the boussinesq.F90 simulations). These subfolders should be labled as 'n256' for example.

Each file contains a detailed description of what the function or script does. Below is an overview of the functions included in this repository.

## List of functions

### *Data Openers*

**mkfilepath** - Creates a string corresponding to the file path desired  

**datopen** - Opens a regular .dat file and returns two lists of numbers, one for the times, and one for the value of the variable at those times  
**spcopen** - Opens an energy specrtum .dat file and returns two lists of numbers, one for the wave numbers, and one for the partial sum of energy of those wavenumbers  
**ncfopen** - Opens a .ncf file and returns a 3D array of the variable at a given time  

### *Plotters*
**datplot** - Creates a timeplot of a regular .dat file  
**spcplot** - Plots the energy spectrum on a log-log scale  
**ncfplot** - Creates a 2D slice (pcolor) plot of a variable at a given time 

### *Mathematical*
**fourierinterp** - Uses a fourier transform method to interpolate a 2D array of values  
**fftsmooth** - Uses a Gaussien filter to smooth out a list of data

**deriv** - Uses finite differences or a Fourier method to approximate the derivative of a discrete list

**getridx** - Helper to load (or calculate if needed) indexes of 3D wavenumbers in MATLAB's fft format  
rsum - Uses getridx to sphericaly sum over a constant radius values in a 3D array   

**slice3d** - Slices a 3D array into a 2D array on a given plane at a given depth  

**showmtx** - Takes a 2D spectral matrix and graphs the zero values as gray and non-zero values as green and find the width of the non-zero part

### *Physics*
**kolwavenum** - Calculates the Kolmogrorov Dissipation Wavenumber for a given energy spectrum  
**tofmaxval** - Finds the time of the max value in a list of data  
**tofbreak**  - Finds the time of wave breaking using various methods such as a threshold or max-decay condition  


## List of scripts

### *Comparisons*
**datcomp** - Uses datplot to plot a variable for multiple runs and uses tofbreak/tofmaxval to find the corresponding times of break or max vorticity  
**spccomp** - Uses spcplot to plot the energy spectrum for multiple n's at a given time   
**ncfcomp** - Uses ncfplot to plot a 2D slice of a variable for multiple n's  

**subplotmtx** - Uses ncfplot to create a 'subplot matrix' of pcolor plots for multiple n's  

### *Potential Vorticity and Enstrophy*
**pvspc** - Calculates the potential vorticity and its spectrum along with the dissipation wavenumbers and loglog plots them  
**pvcomp** - Plots the potential vorticity spectrum for a given n at multiple times
**pvtavg** - Like pvcomp but takes a time average of the different graphs rather than ploting them separately  
**pvscript** - Old version of penstrophy  
**penstrophy** - Calculates the partial and total potential enstrophy and plots it  
**pexcorr** - Plots the cross-correlation of the potential enstrophy with another time data variable along with normilized graphs of the PE and the variable  

### *Other*
**mktable** - Test idea to create a table of data that all these functions/scripts could reference and have consistent default settings  
