# BrainModel3D
For estimating where tetrodes will go from your surgery coordinates and for choosing good coordinates from a 3D version of the Rat Brain Atlas

% change base to wherever you put the folder
	addpath(genpath('D:/BrainModel/scripts'))
	cd('D:/BrainModel/')

% try it out with my pre-defined areas and an example tetrode arrangement
	load('CoordinateInfo.mat')
% edit the paths included in CoordinateInfo to go from your base path
	imagefile = 'NAc64TT.png';
	areas_to_plot = [1 3 2 4 5 6];

% run the GUI
	run_brainmodel(CoordinateInfo,areas_to_plot,imagefile)
