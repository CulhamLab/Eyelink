function Connect

%% Connect

% Initialization of the connection with the Eyelink Gazetracker.
% exit program if this fails.
if ~EyelinkInit(0), error('Error: Eyelink Init aborted.\n'); end

% check the version of the eye tracker and version of the host software
[v vs] = Eyelink('GetTrackerVersion');
fprintf('Running on a ''%s'' tracker.\n', vs);

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% Set defaults

% Set options: Events and Data Processing
Eyelink('command', 'head_subsample_rate = 0');	      % normal (no anti-reflection)
Eyelink('command', 'select_parser_configuration = 0');% set saccade detection sensitivity: 0 - standard, 1 - high
Eyelink('command', 'heuristic_filter = 1,1');	      % <linkfilter> <filefilters>; 0 - no filter, 1 - moderate (1 sample delay), 2 - extra level of filtering (2 sample delay)

% Set options: Tracking 
Eyelink('command', 'pupil_size_diameter = NO');	 % no for pupil area (yes for dia)
Eyelink('command', 'simulate_head_camera = NO'); % NO to use head camera

% sets what events can be sent over the link while not recording
Eyelink('command', 'link_nonrecord_events = MESSAGE,BUTTON,INPUT');

% Sets how velocity information for saccade detection is to be computed
Eyelink('command', 'recording_parse_type = GAZE'); % GAZE or HREF, almost always GAZE