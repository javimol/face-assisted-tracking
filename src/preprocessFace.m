function x = preprocessFace(img, cfg)
%PREPROCESSFACE Resize and photometrically normalize a face image.
%
%   x = preprocessFace(img, cfg) returns the face as a column vector of
%   doubles (prod(cfg.imageSize) x 1, row-major order) after:
%     1. keeping the first colour channel, as in the original experiments,
%     2. bilinear resizing to cfg.imageSize (QCIF),
%     3. shifting/scaling its grey levels to cfg.targetMean / cfg.targetStd,
%        which reduces the influence of lighting conditions.

if nargin < 2
    cfg = eigenfaceConfig();
end

img = double(img(:,:,1));
img = imresize(img, cfg.imageSize, 'bilinear');

x = reshape(img', [], 1);
x = (x - mean(x)) * cfg.targetStd / std(x) + cfg.targetMean;
end
