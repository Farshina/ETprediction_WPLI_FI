# ETprediction_WPLI_FI

**Evapotranspiration Interpolation**
This MATLAB project demonstrates the use of weighted piecewise linear interpolation (WPLI) and forward interpolation (FI) techniques to fill gaps in evapotranspiration (ET) data obtained from aerial imagery flights. 

**Supplementary documents**
Abstract and Presentation link: https://scisoc.confex.com/scisoc/2022am/meetingapp.cgi/Paper/143951 
A written description of the methods in "WPLI FI theory.docx"

**Overview**
The project includes MATLAB scripts and functions to:

1. Generate synthetic ET data for testing interpolation methods.
2. Perform weighted piecewise linear interpolation (WPLI) between consecutive flight dates.
3. Perform forward interpolation (FI) using a unidirectional approach.

The interpolated ET maps are visualized and stored in cell arrays for further analysis or visualization.

**Prerequisites**
1. MATLAB (version R2019a or later recommended)
2. MATLAB Image Processing Toolbox (for handling image data)
3. MATLAB Statistics and Machine Learning Toolbox (for statistical calculations)


**Files**
The project consists of the following files:

1. main_ET_interpolation_WPLI_FI.m: Main script to orchestrate dataset generation and interpolation.
2. weightedpiecewiselinear_interpolation.m: Function to perform WPLI interpolation.
3. forward_interpolation.m: Function to perform forward interpolation.
4. generate_dataset.m: Function to generate synthetic ET data based on provided flight schedules and parameters.

**Usage**
1. Clone the Repository:

2. Open MATLAB and navigate to the project directory.

3. Run the Main Script:

Open main_ET_interpolation_WPLI_FI.m in MATLAB and execute the script. This will:

i. Generate synthetic ET data.
ii. Perform WPLI and FI interpolations between consecutive flight dates.
iii. Display or save the interpolated ET maps.

4. Explore Results:

The interpolated ET maps (ETmaps_interpolated_WPLI and ETmaps_interpolated_FI) are stored as cell arrays and can be further analyzed or visualized as per your requirements.

**License**

**Acknowledgments**
