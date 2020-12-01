function TT = makeTT_FromImage(imagefile)

% use getpts to extract target AP & ML coordinates of each tetrode
% then convert from pixels to stereotaxic coordinates (mm)
savecoords = ['TT_Image_' imagefile(1:end-4) '.mat'];

if ~exist(savecoords,'file')            
    pt = NaN(2,2);
    
    figure, imshow(imread(imagefile));
    
    title('Click on 0 AP')
    [pt(1,1),~] = getpts;

    title('Click on 1/-1 AP')
    [pt(1,2),~] = getpts;
    
    title('Click on 0 ML')
    [~,pt(2,1)] = getpts;

    title('Click on 1/-1 ML')
    [~,pt(2,2)] = getpts;
    
    conv(1,1) = abs(pt(1,2)-pt(1,1));
    conv(2,1) = abs(pt(2,2)-pt(2,1));        

    title('Click on center of each tetrode...')
    [x,y] = getpts; % press enter after selecting last point
    
    TTx = (pt(1,1)-x)/conv(1);
    TTy = (pt(2,1)-y)/conv(2);
    TT = [TTx TTy];
    save(savecoords,'TT')
    
    close all
else
    load(savecoords)   
    disp('Already TT locations from that image')
end
