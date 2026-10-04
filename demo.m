% DEMO Build the face space from data/gallery and classify a single image.
%
%   Edit probeFile to point at any face crop, then run:  >> demo

addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));

galleryDir = fullfile('data', 'gallery');
probeFile  = fullfile('data', 'probes', 'subject3', 'captura5.png');

model = buildEigenfaces(galleryDir);
plotFaceSpace(model);

[ranking, scores] = classifyFace(model, probeFile);
plotReconstruction(model, probeFile);

fprintf('Ranking for %s:\n', probeFile);
for i = 1:numel(ranking)
    fprintf('  %d. %-12s %5.1f%%\n', i, model.labels{ranking(i)}, 100 * scores(i));
end
