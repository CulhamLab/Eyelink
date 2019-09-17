%Returns the directory containing the file at filepath (always returns lower case)
function [directory] = GetFilepathDirectory(filepath)
fs = find(filepath==filesep,1,'last');
if isempty(fs)
    directory = [];
else
    directory = filepath(1:fs);
end