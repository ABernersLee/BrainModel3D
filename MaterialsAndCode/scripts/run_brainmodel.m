function run_brainmodel(CoordinateInfo,areas_to_plot,imagefile)

close all

%Need CoordinateInfo structure made already
cd(CoordinateInfo.savedir)

%load tetrodes from image of saggital view of brain
makeTT_FromImage(imagefile);

%create/load the areas you are interested in and plot in 3d
    %can load different tetrode configs
    %and change around your tetrode placement, save those and plot
    %coronal slices or 3d image of final tetrode position
plot_areas_andaddTT(CoordinateInfo,areas_to_plot,imagefile(1:end-4))

