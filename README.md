 # BB_PD

BB_PD is a three-dimensional bond-based peridynamic code developed in MATLAB and C. The code is structured into three modules: (1) input module, (2) core computational kernel, (3) post-processing module. The input and output of data is controlled by a programme written in MATLAB. The core functions are written in C and called from MATLAB for optimal performance. The code makes use of shared memory parallelism using OpenMP. The scalability of the code has been tested on a Cascade Lake Node with 56 cores.

## Getting started

This code was developed for the authors PhD and has not been fully documented and tested. To understand the full capabilities of this code, please contact the author for a copy of his PhD thesis (note that this will be available online in the near future). All the results presented in the authors thesis were generated using this code.

[PeriPy](https://github.com/alan-turing-institute/PeriPy) provides a lightweight, open-source and high performance python package for peridynamic simulations. PeriPy utilises the heterogeneous nature of OpenCL so that it can be executed on any platform with CPU or GPU cores. PeriPy is fully documented... recommended over this repository. 

Please feel free to contact the author if you wish to use this code and are having difficulties getting started. 

## Input module

## Core computational kernel

```
MAIN('Beam_4_UN_DX5mm.mat', 8)
```

## Post-processing module

## Examples

## Publications

M. Hobbs, Three-dimensional peridynamic modelling of quasi-brittle structural elements, Department of Engineering, University of Cambridge, 2021. PhD thesis

[Predicting shear failure in reinforced concrete members using a three-dimensional peridynamic framework](https://engrxiv.org/jhnd6/)

[PeriPy - A High Performance OpenCL Peridynamics Package](https://arxiv.org/abs/2105.04150)

[github.com/alan-turing-institute/PeriPy](https://github.com/alan-turing-institute/PeriPy)

## Author
Mark Hobbs (mch61@cam.ac.uk), Department of Engineering, University of Cambridge 

Current email address - mhobbs@turing.ac.uk