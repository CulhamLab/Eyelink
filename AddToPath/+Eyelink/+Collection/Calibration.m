function Calibration

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% defaults

% set calibration settings
Eyelink('command', 'calibration_type = HV9');
Eyelink('command', 'enable_automatic_calibration = NO');	% YES default
Eyelink('command', 'randomize_calibration_order  = YES');	% YES default
Eyelink('command', 'automatic_calibration_pacing = 1000');	% 1000 ms default
Eyelink('Command', 'generate_default_targets = YES');

%get global el from prior steps
global el

% Calibrate the eye tracker
% setup the proper calibration foreground and background colors
el.backgroundcolour        = [100 100 100];
el.calibrationtargetcolour = [0 0 0];

% parameters are in frequency, volume, and duration
% set the second value in each line to 0 to turn off the sound
el.cal_target_beep               = [600 0 0.05];
el.drift_correction_target_beep  = [600 0 0.05];
el.calibration_failed_beep       = [400 0 0.25];
el.calibration_success_beep      = [800 0 0.25];
el.drift_correction_failed_beep  = [400 0 0.25];
el.drift_correction_success_beep = [800 0 0.25];
el.calibrationtargetsize         = 1.5;
el.calibrationtargetwidth        = 0.7;
el.calibrationtargetcolour       = [20 20 20];

% you must call this function to apply the changes from above
EyelinkUpdateDefaults(el);

%% calibrate
EyelinkDoTrackerSetup(el);