function EyelinkSetupScreen(window)

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% setup screen

% Get Screen Size
rect = Screen('Rect', window);
width = rect(3) - rect(1);
height = rect(4) - rect(2);

% Provide Eyelink with details about the graphics environment
% and perform some initializations. The information is returned
% in a structure that also contains useful defaults
% and control codes (e.g. tracker state bit and Eyelink key values).
global el
el = EyelinkInitDefaults(window);

% SET UP TRACKER CONFIGURATION
% Setting the proper recording resolution, proper calibration type, as well as the data file content;
% These commands can be found in physical.ini
Eyelink('command', 'screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
Eyelink('command', 'screen_phys_coords = '); % distance of the visible part of the display screen edge
	                                         % relative to the center of the screen (measured in in millimeters).
                                             % <left>, <top>, <right>, <bottom>
Eyelink('command', 'screen_distance = '); % <mm to top> <mm to bottom> distance in mm to the screen

