function gui_main

%% Global
global EATGlobal;

%% Clear Prior
%close existing figure if there is one
if isfield(EATGlobal, 'fig_main') && isfield(EATGlobal.fig_main, 'fig') && ishandle(EATGlobal.fig_main.fig)
    close(EATGlobal.fig_main.fig);
end

%clear old figure data
EATGlobal.fig_main = [];

%% Open New
%open new figure
EATGlobal.fig_main.fig = open([EyelinkAnalysisTool.getpath 'gui_main.fig']);

%% Initialize
%TODO