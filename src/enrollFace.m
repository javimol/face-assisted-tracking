function [model, id] = enrollFace(galleryDir, imageFile, label)
%ENROLLFACE Add a new identity to the gallery and rebuild the face space.
%
%   [model, id] = enrollFace(galleryDir, imageFile) copies imageFile into
%   galleryDir, recomputes the eigenfaces and returns the new model with the
%   gallery index assigned to the image.
%
%   [model, id] = enrollFace(galleryDir, imageFile, label) stores the image
%   under the given identity label instead of its original file name.

[~, name, ext] = fileparts(imageFile);
if nargin >= 3
    name = label;
end

copyfile(imageFile, fullfile(galleryDir, [name ext]));
model = buildEigenfaces(galleryDir);

ranking = classifyFace(model, imageFile);
id = ranking(1);
end
