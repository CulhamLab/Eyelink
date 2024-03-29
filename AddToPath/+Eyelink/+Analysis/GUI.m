function GUI

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
EATGlobal.fig_main.fig = open([GetGUIPath 'gui_main.fig']);

%% Setup

%add callbacks
% menu_file_save
% menu_file_open
% menu_file_import
% menu_log_save
% menu_log_clear
% toolbar_save
% toolbar_open
% toolbar_import

%get tags:
% edit_log

%% Log

%todo