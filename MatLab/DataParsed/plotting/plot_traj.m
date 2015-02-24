function hAx = plot_traj(dp1,dp2,sourceData,frs,mycolor,stitle)

color{1} = 'k';
color{2} = 'b';
if exist('mycolor','var')
    color = mycolor;
end
if ~exist('stitle','var')
    stitle = '';
end

frs = round(frs);

if exist('sourceData','var')
    switch(sourceData)
        case 'cm'
             xy1(:,:,1) =  getWOI(dp1.video.cm.xy(:,1),dp1.video.pokeIn_fr,[0 frs]);
             xy1(:,:,2) =  getWOI(dp1.video.cm.xy(:,2),dp1.video.pokeIn_fr,[0 frs]);
             xy2(:,:,1) =  getWOI(dp2.video.cm.xy(:,1),dp2.video.pokeIn_fr,[0 frs]);
             xy2(:,:,2) =  getWOI(dp2.video.cm.xy(:,2),dp2.video.pokeIn_fr,[0 frs]);
            
        case 'extremeNose'
            xy1 =  dp1.video.extremes(:,1:frs,[4 3]);
            xy2 =  dp2.video.extremes(:,1:frs,[4 3]);
            
        otherwise
            display('Source data UNKNOWN')
    end
end

framerate = round(dp1.video.info.meanFrameRate);

xy1 = xy1*10/640*10; % convert to mm
xy2  = xy2*10/640*10; % convert to mm


xtime = [1:length(xy1)]/framerate;
scoord = ['x','y'];
for icoord = 1:2
    
    hAx(icoord) = subplot(2,2,icoord);
    if icoord == 1
        title(stitle,'Interpreter','none')
    end
    if ~isempty(xy1)
        if size(xy1,1)>1
            [hl hp] = errorPatch(xtime',nanmean(xy1(:,:,icoord))',nansem(xy1(:,:,icoord))');
            setColor(hl,color{1});setColor(hp,color{1});
        else
            hl  = line(xtime,(xy1(:,:,icoord)));
            setColor(hl,color{1});
        end
    end
    if ~isempty(xy2)
        if size(xy2,1)>1
            [hl hp] = errorPatch(xtime',nanmean(xy2(:,:,icoord))',nansem(xy2(:,:,icoord))');
            setColor(hl,color{2});setColor(hp,color{2});
        else
            hl  = line(xtime,(xy2(:,:,icoord)));
            setColor(hl,color{2})
        end
    end
    
    ylabel(scoord(icoord));
end
xlabel('time (s)')

hAx(end+1) = subplot(2,2,3);cla
if ~isempty(xy2)
    spd =sqrt(diff(xy2(:,:,1)').^2+diff(xy2(:,:,2)').^2);
    spd = filtdata(spd,framerate,5,'low');
    if size(spd,2)>1
        [hl hp] = errorpatch(xtime(1:end-1)',nanmean(spd')',nansem(spd')');
        setColor(hl,color{2});setColor(hp,color{2});
    else
        [hl ] = line(xtime(1:end-1)',(spd')');
        setColor(hl,color{2});
    end
    set(hl,'linewidth',1)
end

if ~isempty(xy1)
    spd =sqrt(diff(xy1(:,:,1)').^2+diff(xy1(:,:,2)').^2);
    spd = filtdata(spd,framerate,5,'low');
    if size(spd,2)>1
        [hl hp] = errorpatch(xtime(1:end-1)',nanmean(spd')',nansem(spd')');
        setColor(hl,color{1});setColor(hp,color{1});
    else
        [hl ] = line(xtime(1:end-1)',(spd')');
        setColor(hl,color{1});
    end
    set(hl,'linewidth',1)
end
axis tight
title('speed')
xlabel('time (s)')

setAxEq(hAx(1:3),'x');

hAx(end+1)  = subplot(2,2,4);
if ~isempty(xy2)&~isempty(xy1)
    % [hl ] = line(nanmean(xy1(:,:,1))',nanmean(xy1(:,:,2))','linestyle','o','linewidth',1,'markersize',3);
    % [hl ] = line(nanmedian(xy1(:,:,1))',nanmedian(xy1(:,:,2))','linestyle','o','linewidth',1,'markersize',3);
    [hl ] = line((xy1(:,:,1))',(xy1(:,:,2))','linewidth',1,'markersize',3);
    setColor(hl,color{1});
    % [hl ] = line(nanmean(xy2(:,:,1))',nanmean(xy2(:,:,2))','linestyle','o','linewidth',1,'markersize',3);
    % [hl ] = line(nanmedian(xy2(:,:,1))',nanmedian(xy2(:,:,2))','linestyle','o','linewidth',1,'markersize',3);
    [hl ] = line((xy2(:,:,1))',(xy2(:,:,2))','linewidth',1,'markersize',3);
    setColor(hl,color{2});
    xlabel('x')
    ylabel('y')
end
plotAnn(dp1.FileName);




% frs = framerate*0.6;
