 # BB_PD

BB_PD is a three-dimensional bond-based peridynamics code developed in MATLAB and C. The code is structured into three modules: (1) input module, (2) core computational kernel, (3) post-processing module. The input and output of data is controlled by a programme written in MATLAB. The core functions are written in C and called from MATLAB for optimal performance. The code makes use of shared memory parallelism using OpenMP. The scalability of the code has been tested on a Cascade Lake Node with 56 cores.

## Code features
* Linear / bilinear / trilinear / non-linear constitutive models
* Interface constitutive model
* Contact model
* Validated on a wide range of carefully selected experiments [1]
* Mature explicit solver
* Skeleton implicit solver (requires optimisation to solve non-trivial problems with 10,000+ nodes in resonable time)
* Run simulations with 500,000+ particles 

## Disclaimer

This code was developed by **Mark Hobbs** for his PhD and has not been fully documented and tested. To understand the full capabilities of this code, please contact the author for a copy of his PhD thesis (note that this will be available online in the near future). The code has been in continuous development and best software practices were not in place, therefore, some functionality that was previously available might now be missing. The author intends to reinstate previously available functionality over the coming months. 

## Getting started

Running a simulation is easy. Simply download the code to your local computer. Open up ```BB_PD/main/``` and run ```MAIN.m``` as follows:

```MAIN('Beam_3_UN_DX5mm.mat', 8)```

Where ```Beam_3_UN_DX5mm.mat``` is the input file (created using the input module) and `8` is the number of threads that you wish to use. Note that if your computer uses hyperthreading, OpenMP might incorrectly believe that you have double the number of physical cores and this will cause a segmentation error.  

### Compiling

The C code will need to be compiled to a mex function (MATLAB executable). MATLAB does not officially support the use of OpenMP with mex functions, but with varying degrees of complexity, it is possible on Linux, Windows and MacOS. 

**Linux:** compiling with OpenMP is relatively simple on a Linux system using gcc.

**Windows:** if you are using a Windows machine with an Intel CPU, the author recommends the use of icc (Intel C/C++ compiler). This produces highly optimised code that will run significantly faster.

**MacOS:** the use of OpenMP with mex functions is significantly more complicated on MacOS but it is possible. The following link provides details for... clang is the only compatable compiler. In the author's experience, code compiled with clang will run significanly slower than icc. 

The author intends to provide a pure MATLAB code in the future for educational purposes. 

### Help

Please feel free to contact the author if you wish to use this code and are having difficulties getting started. 

# Examples

All the results presented in the authors PhD thesis were generated using this code. This section illustrates three non-trivial fracture problems that have been simulated using this code. Input files are provided for example 1 and 2. The post-processing and visualisation of output data is also handled by the code.

## 1. unnotched beam

```Input file: Beam_3_UN_DX5mm.mat```

This section illustrates the simulation of an unnotched beam in three-point bending. 

## 2. mixed-mode fracture

```Input file: d_80mm_e_pt625d_DX5mm.mat```

This section illustrates the simulation of a mixed-mode fracture problem. The ability to accurately predict mixed-mode fracture is an important check on the validity of a numerical model. Many problems of interest (industrially motivated problems) will exhibit mixed-mode behaviour. 

![Mixed](docs/animations/d_80mm_e_pt625d_DX1pt25mm.gif)

## 3. shear failure

This section illustrated the simulation of a reinforced concrete beam failing in shear. 

The code is currently not configured to run this example but the author intends to reinstate this functionality in the near future. 

![Stuttgart Shear Tests - Beam 7](docs/images/SB7_deformed.png)
![Stuttgart Shear Tests - Beam 7](docs/images/SB7_fracture_paths.png)

## Publications

M. Hobbs, Three-dimensional peridynamic modelling of quasi-brittle structural elements, Department of Engineering, University of Cambridge, 2021. PhD thesis

[Predicting shear failure in reinforced concrete members using a three-dimensional peridynamic framework](https://engrxiv.org/jhnd6/)

## Future development

There are no plans for further extensive development of this code but the author intends to:

* Provide a pure MATLAB code in the future for educational purposes
* Remove redundant functions 
* Improve code documentation
* There are no plans to write unit tests etc

## PeriPy

[PeriPy](https://github.com/alan-turing-institute/PeriPy) provides a lightweight, open-source and high performance python package for peridynamic simulations. PeriPy utilises the heterogeneous nature of OpenCL so that it can be executed on any platform with CPU or GPU cores. PeriPy is fully documented... recommended over this repository. 

[PeriPy - A High Performance OpenCL Peridynamics Package](https://arxiv.org/abs/2105.04150)

[github.com/alan-turing-institute/PeriPy](https://github.com/alan-turing-institute/PeriPy)

# Code structure

## Input module

## Core computational kernel

```
MAIN('Beam_4_UN_DX5mm.mat', 8)
```

## Post-processing module

## Author
Mark Hobbs (mch61@cam.ac.uk), Department of Engineering, University of Cambridge 

Current email address - mhobbs@turing.ac.uk