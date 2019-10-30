function PullEDF(filename_edf, full_filepath_to_copy_to)

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% add extension to filename if not there
if isempty(strfind(filename_edf, '.edf'))
    filename_edf = [filename_edf '.edf'];
end
if isempty(strfind(full_filepath_to_copy_to, '.edf'))
    full_filepath_to_copy_to = [full_filepath_to_copy_to '.edf'];
end

%% get data
fprintf('Pulling edf %s to %s\n', filename_edf, full_filepath_to_copy_to);
try
    status = Eyelink('ReceiveFile', filename_edf, full_filepath_to_copy_to);
    if status<=0
        error('Could not pull file! Status: %d', status)
    end
catch err
    warning('Could not pull EDF')
    rethrow(err)
end

%% takes some time
WaitSecs(0.5);