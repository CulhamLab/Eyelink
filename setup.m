function setup
%add directory to path
disp('Adding directories to path...')
path_to_collection = [pwd filesep 'AddToPath' filesep];
path(path,path_to_collection);
%save path
try
    savepath
catch
    warning('MATLAB Path could not be saved. Directories have been added to the path for this session only.\nThe most common solution is to run MATLAB as admin and try agian.')
end
%done
disp('Setup Complete!')