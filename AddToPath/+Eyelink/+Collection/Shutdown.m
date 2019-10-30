function Shutdown

%% stop if not connected
if Eyelink('IsConnected')~=1, error('Error: not connected'); end

%% shutdown
Eyelink('Shutdown');

%% takes some time
WaitSecs(0.5);