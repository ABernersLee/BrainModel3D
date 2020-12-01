function plot_areas_andaddTT(CoordinateInfo,areas_to_plot,imagefile)

if nargin<3
    imagefile = [];
end

%some or all of the areas you put into CoordinateInfo.PageNumbers.(Area)
fieldareas = fieldnames(CoordinateInfo.PageNumbers);
for ia = 1:length(areas_to_plot)
    area(ia,1).name = fieldareas{areas_to_plot(ia),1};
end

%semi-manually get the conversions and anchor points (0 for ML, -5 for DV)
%for each AP coronal slice. load up once you have done once
fn = fieldnames(CoordinateInfo);
savelabel = 'CoronalPixelConversion';
if ~ismember(savelabel,fn)
    cd(CoordinateInfo.savedir)
    [xcenter, ycenter] = helper_gui_getcoronalslice(CoordinateInfo,savelabel);
    CoordinateInfo.(savelabel).xcenter = xcenter;
    CoordinateInfo.(savelabel).ycenter = ycenter;
    save('CoordinateInfo.mat','CoordinateInfo')
else
    xcenter = CoordinateInfo.(savelabel).xcenter;
    ycenter = CoordinateInfo.(savelabel).ycenter;
end

%these are the pixel to mm conversion factors for each coronal slice
xconv = mean(abs(xcenter(1,:)-xcenter(2,:)));
yconv = mean(abs(ycenter(1,:)-ycenter(2,:)));

%manually define/load the cell layer/boundaries for each area you want to look at together
cd(CoordinateInfo.savedir)
if ~exist(['areas_' strjoin(extractfield(area,'name'),'_') '.mat'],'file')
    for ia = 1:size(area,1)
        %manually define points of each area
        area(ia).pn = CoordinateInfo.PageNumbers.(area(ia).name);
        [area(ia).x,area(ia).y,area(ia).z] = helper_gui_getcoords(area(ia).pn,CoordinateInfo,area(ia).name);

        %convert pixels to mm
        area(ia).x = ((area(ia).x)-(xcenter(1,area(ia).pn)))/xconv;
        area(ia).y = (((ycenter(1,area(ia).pn))-area(ia).y)/yconv)-5;

        %reshape the z axis
        area(ia).z = repmat(area(ia).z',[size(area(ia).x,1) 1]);
    end
    save(['areas_' strjoin(extractfield(area,'name'),'_') '.mat'],'area','CoordinateInfo','areas_to_plot')
else
    load(['areas_' strjoin(extractfield(area,'name'),'_') '.mat'],'area')
end

%semi-manually get the conversions and anchor points (0AP 0ML)
%for each DV Horizontal Slice you have. Load up once you have done once
fn = fieldnames(CoordinateInfo);
savelabel = 'HorizontalPixelConversion';
if ~ismember(savelabel,fn)
    cd(CoordinateInfo.savedir)
    [xcenterH, ycenterH] = helper_gui_gethorizontalslice(CoordinateInfo,savelabel);
    CoordinateInfo.(savelabel).APcenter = xcenterH;
    CoordinateInfo.(savelabel).MLcenter = ycenterH;
    save('CoordinateInfo.mat','CoordinateInfo')
end


% 3dplot the structures you loaded, with a legend
k = figure; hold on; 
set(k,'Position',[0,0,1355,995]);
cc = varycolor(size(area,1));
for ia = 1:size(area,1)
    plot3(area(ia).x,area(ia).z,area(ia).y,'Color',[.5 .5 .5]); 
    plot3([area(ia).x]',[area(ia).z]',[area(ia).y]','Color',[.5 .5 .5]);
    plot3(area(ia).x,area(ia).z,area(ia).y,'.','color',cc(ia,:),'MarkerSize',10); 
end
clear hh
nam = cell(1,size(area,1));
for ia = 1:size(area,1)
    hh(ia,1) = plot3(area(ia).x(1),area(ia).z(1),area(ia).y(1),'.','color',cc(ia,:),'MarkerSize',10);     
    nam{1,ia} = ['''' area(ia).name ''''];    
end
ev = strjoin(nam,',');
eval(['legend(hh,' ev ',''AutoUpdate'',''off'');'])
xlabel('ML'); zlabel('DV'); ylabel('AP');
axis equal; grid on


axx = gca;
Dat = struct;


% Below are all the controls for the GUI, followed by their functions

% Load TTs
u1=uicontrol;
set(u1,'Position',[10 880 100 30]);
set(u1,'Style','Edit','Tag','edit1');
set(u1,'String',num2str(imagefile))
axes('Units','Pixels','Position',[0 900 100 30],'Visible','off');
text(.1,1,'Load Name:','FontSize',12)

u2=uicontrol;
set(u2,'Position',[10 840 100 30]);
set(u2,'UserData',Dat);
set(u2,'Callback',@tt_load)
set(u2,'String','Load TTs','FontSize',14);

%only these TT to use
axes('Units','Pixels','Position',[0 790 100 30],'Visible','off');
text(.1,1,'Tetrodes to Change:','FontSize',12)
u19=uicontrol;
set(u19,'Position',[10 780 100 30]);
set(u19,'Style','Edit','Tag','numTT');

% Move all TT any of the 3 ways
axes('Units','Pixels','Position',[0 720 100 30],'Visible','off');
text(.1,1.7,'Move TT:','FontSize',12)
text(.15,1,'ML','FontSize',12); text(.5,1,'AP','FontSize',12);text(.9,1,'DV','FontSize',12)

u3=uicontrol;
set(u3,'Position',[10 710 30 30]);
set(u3,'Style','Edit','Tag','moveML');
set(u3,'String','0','FontSize',12);

u4=uicontrol;
set(u4,'Position',[45 710 30 30]);
set(u4,'Style','Edit','Tag','moveAP');
set(u4,'String','0','FontSize',12);

u5=uicontrol;
set(u5,'Position',[85 710 30 30]);
set(u5,'Style','Edit','Tag','moveDV');
set(u5,'String','0','FontSize',12);

% Move only the top of TTs
axes('Units','Pixels','Position',[0 670 100 30],'Visible','off');
text(.1,1,'Move Top of TTs:','FontSize',10)

u6=uicontrol;
set(u6,'Position',[10 660 30 30]);
set(u6,'Style','Edit','Tag','moveMLa');
set(u6,'String','0','FontSize',12);

u7=uicontrol;
set(u7,'Position',[45 660 30 30]);
set(u7,'Style','Edit','Tag','moveAPa');
set(u7,'String','0','FontSize',12);

u8=uicontrol;
set(u8,'Position',[85 660 30 30]);
set(u8,'Style','Edit','Tag','moveDVa');
set(u8,'String','0','FontSize',12);

% Move only the bottom of TTs
axes('Units','Pixels','Position',[0 620 100 30],'Visible','off');
text(.1,1,'Move Bottom of TTs:','FontSize',10)

u9=uicontrol;
set(u9,'Position',[10 610 30 30]);
set(u9,'Style','Edit','Tag','moveMLp');
set(u9,'String','0','FontSize',12);

u10=uicontrol;
set(u10,'Position',[45 610 30 30]);
set(u10,'Style','Edit','Tag','moveAPp');
set(u10,'String','0','FontSize',12);

u11=uicontrol;
set(u11,'Position',[85 610 30 30]);
set(u11,'Style','Edit','Tag','moveDVp');
set(u11,'String','0','FontSize',12);


%rotate
axes('Units','Pixels','Position',[0 570 100 30],'Visible','off');
text(.1,1,'Degrees to rotate:','FontSize',10)

u20=uicontrol;
set(u20,'Position',[10 550 100 30]);
set(u20,'Style','Edit','Tag','theta');

% Execute the Move
u12 = uicontrol;
set(u12,'Position',[10 510 100 30]);
set(u12,'Callback',@tt_move);
set(u12,'String','Move TT','FontSize',14);

% Chose how to move - from original, or cumulatively
u21=uicontrol;
set(u21,'Position',[10 440 100 60]);
set(u21,'Style','listbox','Tag','coord_use');
set(u21,'String',{'Accumulate Changes','Change From Orig'},'FontSize',10);

% Rotate Structure
u13=uicontrol;
set(u13,'Position',[10 380 100 30]);
set(u13,'Style','togglebutton')
set(u13,'Callback',@tt_rotate);
set(u13,'String','Rotate Structure','FontSize',10);

% Name new TT Name
axes('Units','Pixels','Position',[0 330 100 30],'Visible','off');
text(.1,1,'Save Name:','FontSize',12)
u16=uicontrol;
set(u16,'Position',[10 320 100 30]);
set(u16,'Style','Edit','Tag','TTName');
set(u16,'String','TempSaveName')

% Make and save out images of cornal slices
u15=uicontrol;
set(u15,'Position',[10 220 100 30]);
set(u15,'Callback',@tt_coronalimages);
set(u15,'String','Coronal Images','FontSize',10);

% Screenshot of Current 3d View
u14=uicontrol;
set(u14,'Position',[10 260 100 30]);
set(u14,'Callback',@tt_screenshot);
set(u14,'String','Screenshot','FontSize',10);

% Make and save out image horizontal slice with all TT
u22=uicontrol;
set(u22,'Position',[10 180 100 30]);
set(u22,'Callback',@tt_horzimages);
set(u22,'String','Horizontal Image','FontSize',10);

% Save new TT
u17=uicontrol;
set(u17,'Position',[10 140 100 30]);
set(u17,'Callback',@tt_save);
set(u17,'String','Save','FontSize',14);

% Quit without Saving
u18=uicontrol;
set(u18,'Position',[10 100 100 30]);
set(u18,'Callback',@tt_quit);
set(u18,'String','Quit','FontSize',14);


    function tt_load(~,~)               
    
    cd(CoordinateInfo.savedir)
    clear x h
    h = findobj('Tag','edit1');    
    x = get(h,'String');
    
    if exist(['TT_Image_' imagefile(1:end-4) '.mat'],'file') || exist(['TT_Image_' x '.mat'],'file')
        
        if exist(['TT_Image_' x '.mat'],'file')
            load(['TT_Image_' x '.mat'],'TT')
        else
            TT = makeTT_FromImage([x '.png']);
        end

        if ismember('ch',fieldnames(Dat))
            ch = Dat.ch;    
            delete(ch)
        end

        if size(size(TT),2)~=3
            tt = cat(3,[TT zeros(size(TT,1),1)],[TT -10*ones(size(TT,1),1)]);
        else tt = TT;
        end

        Dat.tt_orig = tt;
        Dat.tt_new = tt;    
        ch = [];

        axes(axx)
        ch = tt_plot_tt(tt,ch);
        Dat.ch = ch;    
    end
    
    end

    function ch = tt_plot_tt(tt,ch)
    
    delete(ch)    
    
    for itt = 1:size(tt,1)
        ch(itt) = plot3([tt(itt,2,1) tt(itt,2,2)],[tt(itt,1,1) tt(itt,1,2)],[tt(itt,3,1) tt(itt,3,2)],'*-k');
    end

    end
    
    function tt_move(~,~)        
    
    tempy = findobj('Tag','moveML');    
    ML = str2num(get(tempy,'String')); clear tempy
    if isempty(ML); ML = 0; end
    
    tempy = findobj('Tag','moveAP'); 
    AP = str2num(get(tempy,'String')); clear tempy
    if isempty(AP); AP = 0; end
    
    tempy = findobj('Tag','moveDV');
    DV = str2num(get(tempy,'String')); clear tempy
    if isempty(DV); DV = 0; end
    
    
    tempy = findobj('Tag','moveMLa');
    MLa = str2num(get(tempy,'String')); clear tempy
    if isempty(MLa); MLa = 0; end
    
    tempy = findobj('Tag','moveAPa');
    APa = str2num(get(tempy,'String')); clear tempy
    if isempty(APa); APa = 0; end
    
    tempy = findobj('Tag','moveDVa');
    DVa = str2num(get(tempy,'String')); clear tempy
    if isempty(DVa); DVa = 0; end
    
    
    tempy = findobj('Tag','moveMLp');
    MLp = str2num(get(tempy,'String')); clear tempy
    if isempty(MLp); MLp = 0; end
    
    tempy = findobj('Tag','moveAPp');
    APp = str2num(get(tempy,'String')); clear tempy
    if isempty(APp); APp = 0; end
    
    tempy = findobj('Tag','moveDVp');
    DVp = str2num(get(tempy,'String')); clear tempy
    if isempty(DVp); DVp = 0; end        
        
    
    tempy = findobj('Tag','theta');
    theta = str2num(get(tempy,'String')); clear tempy
    if isempty(theta); theta = 0; end
    
    %toggles between accumulating changes (1) and using original
    %coordinates (2)   
    tempy = findobj('Tag','coord_use');
    b_state = get(tempy,'Value');
    
    %rotate
    if b_state == 1
        tt = rotate_tets(Dat.tt_new,theta);
    elseif b_state == 2
        tt = rotate_tets(Dat.tt_orig,theta);
    end
               
    %get TT to shift (can be subset)
    tempy = findobj('Tag','numTT');
    ind = str2num(get(tempy,'String')); 
    if isempty(ind)
        ind = 1:size(tt,1);
    end
    clear tempy
        
    %original plus rotation plus shift
    tt(ind,1,1) = tt(ind,1,1)+AP+APa;
    tt(ind,2,1) = tt(ind,2,1)+ML+MLa;
    tt(ind,3,1) = tt(ind,3,1)+DV+DVa;

    tt(ind,1,2) = tt(ind,1,2)+AP+APp;
    tt(ind,2,2) = tt(ind,2,2)+ML+MLp;
    tt(ind,3,2) = tt(ind,3,2)+DV+DVp;

    Dat.tt_new = tt;
    
    
    axes(axx)
    ch = tt_plot_tt(tt,Dat.ch);
    Dat.ch = ch;
    
%     hObject.UserData = Dat;
    end

    function tt = rotate_tets(TTold,theta)
        
        %rotation
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
        
        
        % use median as the center to rotate around
        c1 = median(TTold(:,1:2,1));
        c2 = median(TTold(:,1:2,1));
        
        %subtract median, rotate, add back median
        tt1 = NaN(size(TTold,1),2,2);
        for itets = 1:size(TTold,1)
            tt1(itets,:,1) = ((squeeze(TTold(itets,1:2,1))-c1)*R)+c1;
            tt1(itets,:,2) = ((squeeze(TTold(itets,1:2,2))-c2)*R)+c2;
        end
        clear itets
        
        % add back the DV dimension
        tt = tt1; tt(:,3,:) = TTold(:,3,:);
    end

    function tt_rotate(hObject,~)
    
        button_state = get(hObject,'Value');
        if button_state == get(hObject,'Max')
            rotate3d on
        elseif button_state == get(hObject,'Min')
            rotate3d off
        end
    end

    function tt_coronalimages(~,~)
        h = findobj('Tag','TTName');
        guisavelabel = get(h,'String');
                
        
        drawTT_CoronalSections(Dat.tt_new,guisavelabel,areas_to_plot,CoordinateInfo)
    end

    function tt_horzimages(~,~)
        h = findobj('Tag','TTName');
        guisavelabel = get(h,'String');
                
        
        drawTT_HorizontalSections(Dat.tt_new,guisavelabel,CoordinateInfo)
    end
    
    function tt_screenshot(~,~)
        h = findobj('Tag','TTName');
        guisavelabel = get(h,'String');
        
        helper_savefig(['3dTT_' guisavelabel])
    end

    function tt_save(~,~)                
        TT = Dat.tt_new;
        
        h = findobj('Tag','TTName');
        guisavelabel = get(h,'String');
        save(['TT_Image_' guisavelabel '.mat'],'TT')
    end

    function tt_quit(~,~)
        close gcf        
    end
        
        

end

