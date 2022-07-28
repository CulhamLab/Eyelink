%% Console house keeping before starting
clc;
clear;

%% INFORMATION YOU NEED TO PROVIDE
%Provide the root path to your data.  This will vary from system to system.
%IMPORTANT! Do not have edf data too deep in multiple directories.  EDF2MAT
%will crash after converting data
DATA_ROOT = 'C:\Users\kungf\OneDrive\Documents\GitHub\Eyelink\Analysis\GazeOnVideo\Data';

%What was the ID for the participant when collecting eye data?
ID = 'IZ05';
SESSION = '01';
RUN = '01';

%What is the source video file name that was recorded during data
%collection?
VIDEO_FILE_NAME_INPUT = 'IZ05_01_01_2022-07-26_12-56-08_1920x1080.mp4';
%What is the desired output file name generatted by this script
VIDEO_FILE_NAME_OUTPUT = "GAZE_WATCH_"+ID+"_Session_"+SESSION+"_Run_"+RUN;

% What frame rate was used for data collection?
EYELINK_FRAME_RATE = 1000;

% Set your marker parameters
MARKER_COLOR = 'blue';
MARKER_SHAPE = 'circle';
MARKER_SIZE = 15;
MARKER_THICKNESS = 5;

% Change the active directory to the DATA_ROOT due to EDF2MAT not being
% able to handle a lot of characters in a file path with a crash
cd(DATA_ROOT)
% Set the file paths to you eye tracking and video data
EDF_FILE_PATH = convertStringsToChars(ID+"/Eye Tracking/Session_"+SESSION+"/Run_"+RUN+"/"+ID+SESSION+RUN+".edf")
VIDEO_FILE_PATH_INPUT = convertStringsToChars(DATA_ROOT+"\"+ID+"\Recordings\Session_"+SESSION+"\Run_"+RUN+"\"+VIDEO_FILE_NAME_INPUT);
% Set the file name for the out video with the eye tracking marker applied
%% Convert and extract the gaze coordinate from the eytracking data
edf = Edf2Mat(EDF_FILE_PATH)

% MOST IMPORTANT BIT!  Grab the eye position in pixels from the edf.samples
% data structure
samples = edf.Samples();

% Round the pixel coordinates so we are using whole numbers
pos_x = round(samples.posX);
pos_y = round(samples.posY);
% Get the first pixel coordinate from the rounded positions
pixel_x = pos_x(1);
pixel_y = pos_y(1);
% If the first coordinate is NAN just set the marker to the middle off the
% screen

%% Extract the required video data from the video file
video_frames = VideoReader(VIDEO_FILE_PATH_INPUT)
video_frame_rate = video_frames.FrameRate;
video_frame_width = video_frames.Width;
video_frame_height = video_frames.Height;

%% Setup the video variables
% Setup some video frame variables needed when processin the video in the
% loop below
video_frame_index = 30;
video_frame_step = (1/video_frame_rate)*EYELINK_FRAME_RATE;
video_frame_total = video_frames.numFrames;

% If the first pixel coordinate is NAN just use the middle pixel
if(isnan(pixel_x))
    pixel_x = video_frame_width/2;
end
if(isnan(pixel_y))
    pixel_y = video_frame_height/2;
end

%% Setup the video writer that will comply the new output video
if exist(strcat(VIDEO_FILE_NAME_OUTPUT,'.mp4'), 'file')==2
  delete(strcat(VIDEO_FILE_NAME_OUTPUT,'.mp4'));
end

video_writer = VideoWriter(VIDEO_FILE_NAME_OUTPUT,'MPEG-4');
video_writer.FrameRate = video_frame_rate;
open(video_writer);

%% Process all frames in the video file and build the new video
while hasFrame(video_frames)
    
    % Write the video frame with the the marker at the current pixel
    % position
    video_frame = readFrame(video_frames);
    marker_on_frame = insertShape(video_frame,MARKER_SHAPE,[pixel_x pixel_y MARKER_SIZE],'LineWidth',MARKER_THICKNESS,'Color',MARKER_COLOR);
    %See the output of a painted frame with imshow NOTE! This will GREATLY
    %slow down processing.  Only use for debugging.
    %imshow(RGB);
    
    %Save a new video frame
    writeVideo(video_writer,marker_on_frame);

    % Update the current video frame number and multiply that by the step to
    % get the associated eyelink data index
    video_frame_index = video_frame_index + 1;    
    eyelink_index = floor(video_frame_index * video_frame_step);
    
    % Check that the eyelink index is not larger then the number of
    % available indeces.  If so just set it to the end of the eyelink data.
    if(eyelink_index > numel(pos_x))
        eyelink_index = numel(pos_x)-1;
    end
    
    % Store the previous pixel coordinate just in case we need to use it
    % again
    previous_pixel_x = pixel_x;
    previous_pixel_y = pixel_y;
    
    % Get new pixel data that is aligned with the point in time of the
    % source video
    pixel_x = pos_x(eyelink_index);
    pixel_y = pos_y(eyelink_index);
    
    % If the pixel is out of bounds set it to bounds value
    if(pixel_x > video_frame_width-1)
        pixel_x = video_frame_width;
    elseif(pixel_x < 1)
        pixel_x = 0;
    elseif(isnan(pixel_x))
        pixel_x = previous_pixel_x;
    end
    
    if(pixel_y > video_frame_height-1)
        pixel_y = video_frame_height;
    elseif(pixel_y < 1)
        pixel_y = 0;
    elseif(isnan(pixel_y))
        pixel_y = previous_pixel_y;
    end

end
close(video_writer);
disp("Done!");


