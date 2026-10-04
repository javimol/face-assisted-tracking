function files = listImages(folder, cfg)
%LISTIMAGES Sorted full paths of the image files found in a folder.
%
%   files = listImages(folder, cfg) returns a cell array of paths whose
%   extension (case-insensitive) is one of cfg.extensions.

if nargin < 2
    cfg = eigenfaceConfig();
end

entries = dir(folder);
entries = entries(~[entries.isdir]);
names   = sort({entries.name});

files = {};
for i = 1:numel(names)
    [~, ~, ext] = fileparts(names{i});
    if any(strcmpi(ext, cfg.extensions))
        files{end+1} = fullfile(folder, names{i}); %#ok<AGROW>
    end
end

if isempty(files)
    error('listImages:empty', 'No images found in "%s".', folder);
end
end
