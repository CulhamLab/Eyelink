function EyelinkSetFile(filename)

%% check input

%check filename
if ~ischar(filename)
    error('Filename must be a string');
end

%remove .edf from filename if provided
filename = strrep(filename, '.edf', '');

%check that filename is valid
if isempty(filename)
    error('Filename must contain something before .edf')
elseif length(regexp(filename, '\w')) ~= length(filename)
    error('Filename may not contain special characters');
elseif ~isempty(regexp(filename(1), '\d'))
    error('Filename must not begin with a number');
elseif length(filename) > 8
    error('Filenames must be 1 to 8 character not including .edf');
end

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% set file

% open file to record data to
fid = Eyelink('Openfile', filename);
if fid ~= 0, error(['Error: Cannot open EDF file: ' filename]); end

%% config file

% set EDF file contents using the file_sample_data and file-event_filter commands
% set link data through link_sample_data and link_event_filter
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,PUPIL,AREA,STATUS,INPUT');
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,HREF,GAZERES,PUPIL,AREA,STATUS,INPUT');