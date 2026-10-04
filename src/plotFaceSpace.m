function plotFaceSpace(model)
%PLOTFACESPACE Show the gallery, its normalized version, mean face and eigenfaces.

M = numel(model.labels);
K = size(model.eigenfaces, 2);

figure('Name', 'Gallery');
for i = 1:M
    subplot(gridSize(M), gridSize(M), i);
    imshow(imread(model.files{i}));
    title(model.labels{i}, 'Interpreter', 'none');
end

figure('Name', 'Normalized gallery');
for i = 1:M
    subplot(gridSize(M), gridSize(M), i);
    imshow(toImage(model.images(:,i), model.cfg));
    title(model.labels{i}, 'Interpreter', 'none');
end

figure('Name', 'Mean face');
imshow(toImage(model.meanFace, model.cfg));
title('Mean face');

figure('Name', 'Eigenfaces');
for i = 1:K
    subplot(gridSize(K), gridSize(K), i);
    imshow(histeq(mat2gray(toImage(model.eigenfaces(:,i), model.cfg, false))));
    title(sprintf('\\lambda_{%d}', i));
end
end

function n = gridSize(count)
n = ceil(sqrt(count));
end
