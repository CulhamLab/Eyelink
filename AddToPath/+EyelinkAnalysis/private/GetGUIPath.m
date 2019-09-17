function [path] = getpath
full = which('EyelinkAnalysis');

if ~isempty(full)
    path = [full(1:find(full==filesep, 1, 'last')) '+EyelinkAnalysis' filesep 'private'];
else
    warning('EyelinkAnalysis is not on the MATLAB path, which may cause issues. Run setup.m to correct this.')
    path = pwd;
end

if path(end) ~= filesep
    path(end+1) = filesep;
end