%[fixations] = GetFixations(edf, time_start, time_end, allow_outside, restrict)
%
%Returns fixations within start/end time window.
%
%INPUTS:
%edf                edf data structure
%time_start         start time
%time_end           end time
%allow_outside*     true/false to include fixations that are partially in the time window
%restrict*          true/false to restrict fixation start/end times to be within time_start to time_end (for allow_outside = true)
%
%* optional inputs
function [fixations, number_fixations] = GetFixations(edf, time_start, time_end, allow_outside, restrict)

%% Defaults

if ~exist('allow_outside', 'var')
    allow_outside = true;
end

if ~exist('restrict', 'var')
    restrict = true;
end

%% Handle Inputs

if ~isobject(edf) || ~strcmp(class(edf),'Edf2Mat')
    error('Input is not an edf data structure')
end

%% Fixations

ind_start_in_bounds = (edf.Events.Efix.start >= time_start) & (edf.Events.Efix.start < time_end);
ind_end_in_bounds = (edf.Events.Efix.end > time_start) & (edf.Events.Efix.end <= time_end);

if allow_outside
    ind_use = ind_start_in_bounds | ind_end_in_bounds;
else
    ind_use = ind_start_in_bounds & ind_end_in_bounds;
end
ind_fixations = find(ind_use);
number_fixations = length(ind_fixations);

for f = 1:number_fixations
    ind = ind_fixations(f);
    
    if restrict
        fixations(f).start = max([time_start edf.Events.Efix.start(ind)]);
        fixations(f).end = min([time_end edf.Events.Efix.end(ind)]);
    else
        fixations(f).start = edf.Events.Efix.start(ind);
        fixations(f).end = edf.Events.Efix.end(ind);
    end
    
    fixations(f).duration = fixations(f).end - fixations(f).start;
    
    fixations(f).posX = edf.Events.Efix.posX(ind);
    fixations(f).posY = edf.Events.Efix.posY(ind);
    fixations(f).pupilSize = edf.Events.Efix.pupilSize(ind);
    
end