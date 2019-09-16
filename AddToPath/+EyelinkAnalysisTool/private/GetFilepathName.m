%Returns the name of the file at filepath
function [name] = GetFilepathName(filepath)

%% trim path
directory = GetFilepathDirectory(filepath);
filename = strrep(filepath, directory, '');

%% check empty
if isempty(filename)
    error('Empty filename from path: "%s"', filepath)
end

%% check valid
if filename(end) == '.'
    error('Invalid extension for file "%s" (may not end in a period)', filename)
end

%% find name
dot = find(filename=='.',1,'last');
if ~isempty(dot)
    name = filename(1:dot-1);
else
    name = filename;
end