IRM-SA-MATLAB
=============

Knowledge Exchange by Data Classification*
------------------------------------------

### Simulation

This is a simulation of a simple scenario from the firefighter coordination
case study. In the simulation, 4 firefighters are moving on a rectangular map.
Each firefighter makes a move every 1 s (of the simulation time). The position
of a component can change by 1 for X and Y axis at the same time.

For each component, a sample of their position, temperature, oxygen level, 
battery level is obtained every 0.5 s (of the simulation time). The temperature
is sampled based on the position of the component from the corresponding point
on the heat map. The speed of the oxygen level decrease depends whether
the component is moving or not. Moving component consumes more oxygen.
The battery level decreases linearly for each component by an amount generated
randomly in the constructor of the firefighter component.

Each measurement is subject to noise. This is achieved in the simulation
by applying a random noise filter created for each data field of a component.

During the simulation all the values of component’s data fields are recorded
and after the simulation completes, the measured data are analysed.

### Analysis

For each data field, a vector of distances is computed between the values
of the field sampled at the same time on each possible pair of components. 
These vectors of distances are then used to train and test a prediction model. 
The first half of samples are used to train the model and the second half to
test the model. 

In particular, in the simulation we are predicting whether pairs of temperatures
are “close” or “far” according to a predefined proximity threshold (defaults to 20). 

For this, the vectors of differences between position, oxygen level and battery
level are the input of the model. Classes of temperature distances ("close"/"far")
are the output of the model. 
The result of the analysis is a box plot.

*This project is part of the evaluation for the paper “Meta-Adaptation Strategies
for Adaptation in Cyber-Physical Systems”, submitted to SEAMS’15.

### Prerequisites 

The project was coded in MATLAB R2014a. It should work in older versions, but without
any guarantees. All the used functions are a part of the MATLAB libraries,
no additional package should be needed.

### How to run the simulation

The simulation can be run within MATLAB either by calling the simulation function
from command line or by opening the simulation function and hitting the Run button.
In the beginning of the simulation function there are parameters that can be used
to configure the simulation. You can adjust the length of the simulation
and the number of repeated runs. In the end of the simulation there is a script
for analysis of the gathered data invoked. The result of the simulation is a box
plot showing the accuracy and variance of the prediction model based on the number
of samples used for its training.

### Expected output

As seen in the result graph, illustrating growing precision and decreasing variance
of the prediction with increasing number of samples to train the model on.

### Contact

skoda@d3s.mff.cuni.cz
