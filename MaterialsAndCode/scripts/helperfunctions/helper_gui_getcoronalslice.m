function [xcenter,ycenter] = helper_gui_getcoronalslice(CoordinateInfo)
cd(CoordinateInfo.savedir)

if sum(strcmp('CoronalPixelConversion',fieldnames(CoordinateInfo)))==0 %~exist([savelabel '.mat'],'file')
    cd(CoordinateInfo.loaddir)
    
    files = CoordinateInfo.files;
    h = CoordinateInfo.HeightCrop;
    w = CoordinateInfo.WidthCrop;


    xx = NaN(2,length(files));
    yy = NaN(2,length(files));
    clear xtemp ytemp

    for ii = 1:length(files)    %[35, 103, 148]
        clear xtemp ytemp
        filename = files{ii};
        imr = imread(filename);

        figure; 
        imshow(imr(h,w)); 
        title(['Click 0 ML, Slice ' num2str(ii) ' of ' num2str(length(files))])
        hold on
        ys = get(gca,'ylim');
        if ii>1
            plot([xx(1,ii-1) xx(1,ii-1)],[ys(end) ys(1)],'r-')
        end
        [xtemp,~] = getpts; % press enter after        
        if ~isempty(xtemp)
            xx(1,ii) = xtemp;
        else
            xx(1,ii) = xx(1,ii-1);
        end
        clear xtemp 
        close gcf

        figure; hold on        
        imshow(imr(h,w));
        title(['Click -1 or 1 ML, Slice ' num2str(ii) ' of ' num2str(length(files))])
        hold on
        ys = get(gca,'ylim');
        if ii>1
            plot([xx(2,ii-1) xx(2,ii-1)],[ys(end) ys(1)],'r-')
        end
        [xtemp,~] = getpts; % press enter after        
        if ~isempty(xtemp)
            xx(2,ii) = xtemp;
        else
            xx(2,ii) = xx(2,ii-1);
        end
        clear xtemp 
        close gcf

        figure; hold on        
        imshow(imr(h,w));
        title(['Click 5 DV, Slice ' num2str(ii) ' of ' num2str(length(files))])
        hold on
        xs = get(gca,'xlim');
        if ii>1
            plot([xs(1) xs(end)],[yy(1,ii-1) yy(1,ii-1)],'r-')
        end
        [~,ytemp] = getpts; % press enter after        
        if ~isempty(ytemp)
            yy(1,ii) = ytemp;
        else
            yy(1,ii) = yy(1,ii-1);
        end
        clear ytemp 
        close gcf

        figure; hold on        
        imshow(imr(h,w));
        title(['Click 4 or 6 DV, Slice ' num2str(ii) ' of ' num2str(length(files))])
        hold on
        xs = get(gca,'xlim');
        if ii>1
            plot([xs(1) xs(end)],[yy(2,ii-1) yy(2,ii-1)],'r-')
        end
        [~,ytemp] = getpts; % press enter after        
        if ~isempty(ytemp)
            yy(2,ii) = ytemp;
        else
            yy(2,ii) = yy(2,ii-1);
        end
        clear ytemp 
        close gcf
    end
    close all
    xcenter = xx; ycenter = yy;
    
    
    CoordinateInfo.CoronalPixelConversion.xcenter = xcenter;
    CoordinateInfo.CoronalPixelConversion.ycenter = ycenter;
%     save([savelabel '.mat'],'xcenter','ycenter')
    cd(CoordinateInfo.savedir)
    save('CoordinateInfo.mat','CoordinateInfo')
else  
    xcenter = CoordinateInfo.CoronalPixelConversion.xcenter;
    ycenter = CoordinateInfo.CoronalPixelConversion.ycenter;
%     load([savelabel '.mat'],'xcenter','ycenter')
end
