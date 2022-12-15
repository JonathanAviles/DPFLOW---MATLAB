# DPFLOW---MATLAB
Unbalanced Power Flow Calculator for Distribution Networks, implemented using MATLAB

Please, copy all files from this repository to the same folder and run the function 'dpflow' as follows:

outputVariables = dpflow(distCase_test13nodes);

All output info will be available in the structure outputVariables and some of the fields will also be saved to file distCaseResults.m


to run the dpflow you should identify it before 

    addpath( ...
        'C:\Users\USER\Documents\MATLAB\DPflow\DPFLOW---MATLAB', ...
        'C:\Users\USER\Documents\MATLAB\dpflow\DPFLOW---MATLAB\lib', ...
        'C:\Users\USER\Documents\MATLAB\dpflow\DPFLOW---MATLAB\Examples', ...
        '-end' );

## to do
- [ ] modify the input function
- [ ] create lib folder and example folder
- [ ] add the main function with renaming it
- [ ] add the p function with renaming it 
- [ ] add Carlson equation to the toolbox 


## function to add

- [ ] lsatbus() in the IEEE13 
- [ ] 