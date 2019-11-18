 # BB_PD - master branch
BB_PD is a bond based peridynamic analysis code written in MATLAB. This code has been developed primarily for the analysis of reinforced concrete members but extension to other fracture problems is possible.
To see the code in action, simply download the code and edit the configuaration file to accept the desired test problem and run. See 'Tests' for a list of currently available test problems. 

## Authors
Mark Hobbs (mch61@cam.ac.uk), Department of Engineering, Cambridge University

## Simulation Process
The typical simulation process follows four steps.
1. Create input data
2. Build peridynamic particle families and bond lists
3. Solve the problems using a dynamic or static solver
4. Process and visualise the results

## Configuration
- config.newInputFile = 'on/off'
- config.loadInputDataFile = 'filename.mat'
- config.materialModel = 'linear/bilinear/trilinear'
- config.solver = 'dynamic/static'
- config.failureFunctionality = 'on/off'
- config.loadingMethod = 'loadControlled/displacementControlled'
- config.dynamicsolverinputlist = {}
- config.staticsolverinputlist = {}


## Tests
- A1
- A2
- A3
- A4
- B1
- B2
- B3
- C1
- C2
- C3
- C4
- StuttgartBeam5

## 1. Input Module

## 2. Solver Module

## 3. Postprocessing Module

## Output File

## Speed Testing

## Acknowledgements

