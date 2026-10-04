function plotReconstruction(model, img)
%PLOTRECONSTRUCTION Show an input face, its normalized version and its
%reconstruction from the eigenface space, along with the predicted identity.

if ischar(img)
    img = imread(img);
end

[~, reconstruction, reconError, x] = projectFace(model, img);
ranking = classifyFace(model, img);

figure('Name', 'Reconstruction');
subplot(1, 3, 1);
imshow(img);
title('Input');

subplot(1, 3, 2);
imshow(toImage(x, model.cfg));
title('Normalized');

subplot(1, 3, 3);
imshow(toImage(reconstruction, model.cfg));
title(sprintf('Reconstructed (RMS %.1f)', reconError));

annotation('textbox', [0 0 1 0.1], 'String', ...
    sprintf('Predicted: %s', model.labels{ranking(1)}), ...
    'HorizontalAlignment', 'center', 'EdgeColor', 'none', 'Interpreter', 'none');
end
