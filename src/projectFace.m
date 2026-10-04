function [w, reconstruction, reconError, x] = projectFace(model, img)
%PROJECTFACE Project a face image onto the eigenface space.
%
%   [w, reconstruction, reconError, x] = projectFace(model, img)
%     w              - Kx1 weights (coordinates in the eigenface basis)
%     reconstruction - Nx1 face rebuilt from the weights
%     reconError     - RMS error between the normalized input and its
%                      reconstruction (a "distance from face space")
%     x              - Nx1 normalized input face
%
%   img may be an image matrix or a path to an image file.

if ischar(img)
    img = imread(img);
end

x = preprocessFace(img, model.cfg);
w = model.eigenfaces' * (x - model.meanFace);

reconstruction = model.meanFace + model.eigenfaces * w;
reconError = norm(reconstruction - x) / sqrt(numel(x));
end
