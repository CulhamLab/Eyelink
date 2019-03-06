function plot(obj, startIdx, endIdx)
%PLOT plots the edf content to verify if they are useful. For all other
%   post processing you should rather define your own plots
%
%   Syntax: obj.plot();
%           or
%           plot(obj);
%clear
%   See also: Edf2Mat.plot(), Edf2Mat.save()
%             Edf2Mat.Events, Edf2Mat.Samples, Edf2Mat.Header
%             Edf2Mat.about(), Edf2Mat.version()
%
%   <a href = "matlab:Edf2Mat.about">About and Copyright</a>

% AVAILABLE Types: see edf_data.h
% just a few examples:
% #define STARTPARSE 1 	/* these only have time and eye data */
% #define ENDPARSE   2
% #define BREAKPARSE 10
% 
% 			/* EYE DATA: contents determined by evt_data */
% #define STARTBLINK 3    /* and by "read" data item */
% #define ENDBLINK   4    /* all use IEVENT format */
% #define STARTSACC  5
% #define ENDSACC    6
% #define STARTFIX   7
% #define ENDFIX     8
% #define FIXUPDATE  9
% 
%   /* buffer = (none, directly affects state), btype = CONTROL_BUFFER */
% 
% 			 /* control events: all put data into */
% 			 /* the EDF_FILE or ILINKDATA status  */
% #define STARTSAMPLES 15  /* start of events in block */
% #define ENDSAMPLES   16  /* end of samples in block */
% #define STARTEVENTS  17  /* start of events in block */
% #define ENDEVENTS    18  /* end of events in block */
% 
% 
% 
% 	/* buffer = IMESSAGE, btype = IMESSAGE_BUFFER */
% 
% #define MESSAGEEVENT 24  /* user-definable text or data */
% 
% 
% 	/* buffer = IOEVENT, btype = IOEVENT_BUFFER */
% 
% #define BUTTONEVENT  25  /* button state change */
% #define INPUTEVENT   28  /* change of input port */

    assert(isa(obj, 'Edf2Mat'), 'Edf2Mat:plot', ...
        'Only objects of type Edf2Mat can be plotted!');
    
    if ~exist('startIdx', 'var')
        startIdx = 1;
    end
    
    if ~exist('endIdx', 'var')
        endIdx = size(obj.Samples.posX, 1);
    end
    
    range = startIdx:endIdx;
    
    assert(numel(range) > 0, ...
        'Edf2Mat:plot:range','Start Index == End Index, nothing do be plotted');
    
    screenSize = get(0,'ScreenSize');
    figure( 'Position', [screenSize(3)/4 screenSize(4)/4 2*screenSize(3)/3 2*screenSize(4)/3], ...
        'Name', ['Plotting ' obj.filename], ...
        'NumberTitle', 'off', ...
        'Menubar','none');

    
    posX = obj.Samples.posX(range);
    % Y must be inverted, because eyetracker origin
    % is upper left corner in a graph its the lower left
    posY = obj.Samples.posY(range) * -1;

    
    % Ploting Eye Movement
    subplot(2,2,[1 3]);
    plot(posX, posY, 'o', 'Color','blue'); 
    
    title('Plot of the eye movement');
    axis([min(posX) - 1 max(posX) + 1 min(posY) - 1 max(posY) + 1]);
    axis('square');
    xlabel('x-Position');
    ylabel('y-Position');

    % Ploting pupil size
    subplot(2,2,2);
    [tRange, pupil] = obj.getPupilSize(startIdx, endIdx);
    plot(tRange, pupil); 
    
    title('Pupil Size');
    axis('auto');
    xlabel('time [ms]');
    
    % Ploting heatmap
    subplot(2,2,4);
    [heatmap, ~, axisRange] = obj.heatmap(startIdx, endIdx);
    obj.imhandle = imagesc(heatmap);
    % Register the click callbacks:
    % register mouse down function handle
    obj.imhandle.Parent.Parent.WindowButtonDownFcn = @(object, eventdata)obj.mouseClicked(true);
    % register mouse up mouse
    obj.imhandle.Parent.Parent.WindowButtonUpFcn = @(object, eventdata)obj.mouseClicked(false);
    
    set(obj.imhandle.Parent, 'YDir','normal');
    axis(axisRange);
    axis square;
	colorbar;
    title('HeatMap of the eye movement');
    xlabel('x-Position (shifted zero)');
    ylabel('y-Position (shifted zero)');

end