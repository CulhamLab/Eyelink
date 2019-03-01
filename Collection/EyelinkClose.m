function EyelinkClose

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% close
Eyelink('Command', 'set_idle_mode');
Eyelink('CloseFile');

%% takes some time
WaitSecs(0.5);