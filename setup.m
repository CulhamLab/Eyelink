function setup
%add directory to path
disp('Adding directories to path...')
path_to_collection = [pwd filesep 'AddToPath' filesep];
path(path,path_to_collection);
%done
disp('Setup Complete!')