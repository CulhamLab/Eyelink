%[trials] = ParseTrials(filepath_edfmat, search_start, search_end, search_extra, file_write, file_overwrite)
%
%Parses trials based start/end messages and returns messages and fixations.
%By default, the return data is also writtent to file.
%
%INPUTS:
%filepath_edfmat        filepath to edf.mat to read
%search_start           regexp search term for trial start message
%search_end             regexp search term for trial end message
%search_extra*          Nx2 cell matix of [name, search_term] for additional regexp searches, supports token name search (default: empty)
%file_write*            true/false to write output to file (default: true)
%file_overwrite*        true/false to overwrite existing file (default: false)
%
%* optional inputs
function [trials] = ParseTrials(filepath_edfmat, search_start, search_end, search_extra, file_write, file_overwrite)

%% Defaults

if ~exist('file_write', 'var')
    file_write = true;
end

if ~exist('file_overwrite', 'var')
    file_overwrite = false;
end

if ~exist('search_extra', 'var')
    search_extra = cell(0,2);
end

%% Handle Inputs

if ~strcmp(GetFilepathExtension(filepath_edfmat), 'mat')
    filepath_edfmat = [filepath_edfmat '.mat'];
end

if ~iscell(search_extra) || size(search_extra,2)~=2
    error('Invalid extra search')
end

%% Prep

%output filepath
filepath_output = [GetFilepathDirectory(filepath_edfmat) GetFilepathName(filepath_edfmat) '_trials.mat'];

%check overwrite
if file_write && exist(filepath_output, 'file') && ~file_overwrite
    error('Output file already exists and overwrite is diabled: %s', filepath_output);
end

%% Load

fprintf('Loading: %s\n', filepath_edfmat);
file = load(filepath_edfmat);

%check loaded
if ~isfield(file, 'edf')
    error('Loaded file does not contain edf data')
end

%% Find Starts/Ends
ind_trial_starts = find(cellfun(@(x) ~isempty(regexp(x, search_start)), file.edf.Events.Messages.info));
ind_trial_ends = find(cellfun(@(x) ~isempty(regexp(x, search_end)), file.edf.Events.Messages.info));

number_trials = length(ind_trial_starts);
fprintf('Found %d trials...\n', number_trials);

if number_trials ~= length(ind_trial_ends)
    error('Number of trial starts does not match number of trial ends')
end

if any(ind_trial_ends <= ind_trial_starts)
    error('Order of trial starts/ends is mismatched')
end

if any(ind_trial_ends(1:end-1) >= ind_trial_starts(2:end))
    error('Detected trial overlap')
end

%% Parse
number_search_extra = size(search_extra, 1);
trials = repmat(struct('time_start', [], 'time_end', [], 'messages', [], 'searches', [], 'fixations', [], 'number_fixations', []), [number_trials 1]);
for trial = 1:number_trials
    ind_trial_start = ind_trial_starts(trial);
    ind_trial_end = ind_trial_ends(trial);
    
    trials(trial).time_start = file.edf.Events.Messages.time(ind_trial_start);
    trials(trial).time_end = file.edf.Events.Messages.time(ind_trial_end);
    
    trials(trial).messages.time = file.edf.Events.Messages.time(ind_trial_start:ind_trial_end);
    trials(trial).messages.text = file.edf.Events.Messages.info(ind_trial_start:ind_trial_end);
    
    %extra searches
    for e = 1:number_search_extra
        search_name = strrep(search_extra{e,1}, ' ', '_');
        search_term = search_extra{e,2};
        
        if ~isempty(regexp(search_term, '(?<*>*)'))
            result = cellfun(@(x) regexp(x, search_term, 'names'), trials(trial).messages.text, 'UniformOutput', false);
            name_search = true;
        else
            result = cellfun(@(x) regexp(x, search_term), trials(trial).messages.text, 'UniformOutput', false);
            name_search = false;
        end
        ind_result = find(~cellfun(@isempty, result));
        
        if isempty(ind_result)
            field_value = [];
        elseif length(ind_result)==1
            field_value = struct('time', trials(trial).messages.time(ind_result));
            if name_search
                field_value.value = result{ind_result};
            end
        else
            error('Multiple results for extra search %d (%s) in trial %d', e, search_term, trial);
        end
        trials(trial).searches = setfield(trials(trial).searches, search_name, field_value);
        
    end
    
    %fixations
    [trials(trial).fixations, trials(trial).number_fixations] = EyelinkAnalysis.GetFixations(file.edf, trials(trial).time_start, trials(trial).time_end);
    
end
