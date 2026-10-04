function img = toImage(x, cfg, asUint8)
%TOIMAGE Reshape a face column vector (row-major) back into an image.
%
%   img = toImage(x, cfg) returns a uint8 image of size cfg.imageSize.
%   img = toImage(x, cfg, false) keeps the raw double values.

if nargin < 3
    asUint8 = true;
end

img = reshape(x, cfg.imageSize(2), cfg.imageSize(1))';
if asUint8
    img = uint8(img);
end
end
