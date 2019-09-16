%Returns the extension from file at filepath (always returns lower case)
function [extension] = GetFilepathExtension(filepath)

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

%% find exp
dot = find(filename=='.',1,'last');
extension = lower(filename(dot+1:end));