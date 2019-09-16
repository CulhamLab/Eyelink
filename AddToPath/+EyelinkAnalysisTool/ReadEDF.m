%[edf] = ReadEDF(filepath_edf, file_write, file_overwrite)
%
%Reads from "*.edf" and returns the data structure. By default, the
%structure is also written to file.
%
%INPUTS:
%filepath_edf       filepath to edf to read
%file_write*        true/false to write output to file (default: true)
%file_overwrite*    true/false to overwrite existing file (default: false)
%
%* optional inputs
%
%Uses Edf2Mat (Adrian Etter, 2013)
function [edf] = ReadEDF(filepath_edf, file_write, file_overwrite)

%% TEMP
filepath_edf = 'C:\Users\kmstu\Documents\GitHub\Eyelink\Analysis\example.edf';

%% Defaults

if ~exist('file_write', 'var')
    file_write = true;
end

if ~exist('file_overwrite', 'var')
    file_overwrite = false;
end

%% Handle Inputs

%set input to .edf if not already
ext = GetFilepathExtension(filepath_edf);
if isempty(ext) || ~strcmp(ext,'edf')
    filepath_edf = [filepath_edf '.edf'];
end

%display
fprintf('Reading EDF: %s\n', filepath_edf);

%% Prep

%output filepath
filepath_output = [filepath_edf '.mat'];

%check overwrite
if file_write && exist(filepath_output, 'file') && ~file_overwrite
    error('Output file already exists and overwrite is diabled: %s', filepath_output);
end

%% Read
edf = Edf2Mat(filepath_edf);

%% Write
if file_write
    fprintf('Writing EDF.mat: %s\n', filepath_output)
    save(filepath_output, 'edf', 'filepath_edf');
end