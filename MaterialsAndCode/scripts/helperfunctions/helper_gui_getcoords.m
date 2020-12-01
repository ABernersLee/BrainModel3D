function [xx,yy,zz] = helper_gui_getcoords(pn,CoordinateInfo,titlelab)


cd(CoordinateInfo.loaddir)

files = CoordinateInfo.files;
ptsPerImg = CoordinateInfo.ptsPerImg;
ap = CoordinateInfo.AP_Bregma;
h = CoordinateInfo.HeightCrop;
w = CoordinateInfo.WidthCrop;

if exist(['areas_errorsave_' titlelab '.mat'],'file')
    load(['areas_errorsave_' titlelab '.mat'],'xx','yy','zz','st')
else
    xx = NaN(ptsPerImg,length(pn));
    yy = NaN(ptsPerImg,length(pn));
    zz = NaN(length(pn),1);
    st = 1;
end

if st<length(pn)
    try
        for ii = st:length(pn)
            f = pn(ii);
            filename = files{f};
            figure; hold on;
            imr = imread(filename);
            title([titlelab ' Slice ' num2str(ii) ' of ' num2str(length(pn))])
            imshow(imr(h,w));
            [xtemp,ytemp] = getpts; % press enter after final pt    
            xx(:,ii) = xtemp;
            yy(:,ii) = ytemp;
            clear xtemp ytemp
            zz(ii) = ap(f);
            close gcf
        end
        
        st = length(pn);
        save(['areas_errorsave_' titlelab '.mat'],'xx','yy','zz','st')

        cd(CoordinateInfo.savedir)

    catch ME
        close gcf
        st = ii;
        save(['areas_errorsave_' titlelab '.mat'],'xx','yy','zz','st')
        rethrow(ME)
    end
end



