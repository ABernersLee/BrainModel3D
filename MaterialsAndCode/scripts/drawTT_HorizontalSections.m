function drawTT_HorizontalSections(TT,savelabel,CoordinateInfo)
% draw lines on coronal sections representing tetrode tracks


cd(CoordinateInfo.savedir)

[APcenter,MLcenter] = helper_gui_gethorizontalslice(CoordinateInfo); %,'HorizontalPixelConversion');
h = CoordinateInfo.HeightCropHorz;
w = CoordinateInfo.WidthCropHorz;
cd(CoordinateInfo.horzdir)

for iind = 1:length(CoordinateInfo.files_horz)
    
    figure, 
    imr = imread(CoordinateInfo.files_horz{iind});
    imshow(imr(h,w)); hold on
    
    idx = 1:size(TT,1);
    for a = 1:length(idx)
        convML = abs(MLcenter(2,iind)-MLcenter(1,iind));
        convDV = abs(APcenter(2,iind)-APcenter(1,iind));
        TTmla = MLcenter(1,iind)-(TT(idx(a),2,1)*convML);        
        TTmlp = MLcenter(1,iind)-(TT(idx(a),2,2)*convML);        
        TTapa = APcenter(1,iind)-(TT(idx(a),1,1)*convDV);        
        TTapp = APcenter(1,iind)-(TT(idx(a),1,2)*convDV);        
        %plot tt 
        plot(TTapa,TTmla,'*r') 
        plot(TTapp,TTmlp,'*b') 
        %label it         text(TTmla-20,TTdva-20-30*a,['TT ' num2str(idx(a))],'Color','Red','FontSize',14);         
    end
    
    cd(CoordinateInfo.savedir)
    helper_saveandclosefig(['HorizontalTT_' savelabel '_Page' num2str(iind)])    
end