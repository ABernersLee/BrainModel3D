function drawTT_CoronalSections(TT,savelabel,areas_to_plot,CoordinateInfo)
% draw lines on coronal sections representing tetrode tracks


cd(CoordinateInfo.savedir)

AP = CoordinateInfo.AP_Bregma;

diffAP = abs(repmat(TT(:,1),[1 size(AP,1)])-repmat(AP,[size(TT,1) 1]));
[closeTT,closeAP] = find(diffAP==repmat(min(diffAP,[],2),[1 size(diffAP,2)]));
[~,tetord] = sort(closeTT);

if size(closeTT,1)>size(TT,1)
    clear closeTT closeAP tetord
    for itt = 1:size(TT,1)
       closeAP(itt,1) = find(diffAP(itt,:)==min(diffAP(itt,:)),1,'first');
    end
    tetord = 1:size(TT,1);
end


[MLcenter,DVcenter] = helper_gui_getcoronalslice(CoordinateInfo); %,'CoronalPixelConversion');


fns = fieldnames(CoordinateInfo.PageNumbers);
pagestouse1 = [];
for ii = 1:length(areas_to_plot)
    pagestouse1 = [pagestouse1 CoordinateInfo.PageNumbers.(fns{areas_to_plot(ii)})];
end
pagestouse = intersect(unique(pagestouse1),closeAP);
clear pagestouse1
h = CoordinateInfo.HeightCrop;
w = CoordinateInfo.WidthCrop;
TTap = closeAP(tetord);


for APidx = 1:length(pagestouse)    
    cd(CoordinateInfo.loaddir)
    figure, 
    imr = imread(CoordinateInfo.files{pagestouse(APidx)});
    imshow(imr(h,w)); hold on
    
    idx = find(TTap==pagestouse(APidx));
    for a = 1:length(idx)
        convML = (abs(MLcenter(2,pagestouse(APidx))-MLcenter(1,pagestouse(APidx))));
        convDV = (abs(DVcenter(2,pagestouse(APidx))-DVcenter(1,pagestouse(APidx))));
        TTmla = MLcenter(1,pagestouse(APidx))+(TT(idx(a),2,1)*convML);        
        TTmlp = MLcenter(1,pagestouse(APidx))+(TT(idx(a),2,2)*convML);        
        TTdva = DVcenter(1,pagestouse(APidx))-convDV*5-(TT(idx(a),3,1)*convDV);        
        TTdvp = DVcenter(1,pagestouse(APidx))-convDV*5-(TT(idx(a),3,2)*convDV);        
        %plot tt 
        plot([TTmla TTmlp],[TTdva TTdvp],'r')  %[DVcenter(1,pagestouse(APidx))-(5*convDV) DVcenter(1,pagestouse(APidx))+(5*convDV)],'r')        
        %label it
        text(TTmla-20,TTdva-20-30*a,['TT ' num2str(idx(a))],'Color','Red','FontSize',14);         
    end
    
    cd(CoordinateInfo.savedir)
    helper_saveandclosefig(['CoronalTT_' savelabel '_Page' num2str(pagestouse(APidx))])    
end