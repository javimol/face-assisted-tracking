% RUNWALKWAYEXPERIMENT Identify every head-tracker capture against the gallery.
%
%   Expects one gallery image per identity in data/gallery/<label>.png and the
%   tracker captures of each identity in data/probes/<label>/*.png, where
%   <label> matches the gallery file name. A probe identical to its identity's
%   gallery image is skipped, since it would trivially match itself.
%   Prints per-identity accuracy and
%   a confusion matrix, and writes every prediction to results/predictions.csv.

addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));

galleryDir = fullfile('data', 'gallery');
probesDir  = fullfile('data', 'probes');
outputFile = fullfile('results', 'predictions.csv');

model = buildEigenfaces(galleryDir);
M = numel(model.labels);
confusion = zeros(M);

if ~exist('results', 'dir')
    mkdir('results');
end
fid = fopen(outputFile, 'w');
fprintf(fid, 'subject,file,predicted,correct\n');

fprintf('\n%-12s %8s %8s %9s\n', 'Identity', 'Correct', 'Total', 'Accuracy');
for c = 1:M
    subjectDir = fullfile(probesDir, model.labels{c});
    if ~exist(subjectDir, 'dir')
        warning('No probes for "%s" in %s', model.labels{c}, subjectDir);
        continue;
    end

    probes = listImages(subjectDir, model.cfg);
    galleryImage = imread(model.files{c});
    for p = 1:numel(probes)
        % The gallery frame trivially matches itself: leave it out.
        if isequal(imread(probes{p}), galleryImage)
            continue;
        end
        ranking = classifyFace(model, probes{p});
        predicted = ranking(1);
        confusion(c, predicted) = confusion(c, predicted) + 1;

        [~, name, ext] = fileparts(probes{p});
        fprintf(fid, '%s,%s,%s,%d\n', model.labels{c}, [name ext], ...
            model.labels{predicted}, predicted == c);
    end

    total = sum(confusion(c,:));
    fprintf('%-12s %8d %8d %8.1f%%\n', model.labels{c}, confusion(c,c), ...
        total, 100 * confusion(c,c) / total);
end
fclose(fid);

fprintf('\nOverall accuracy: %.1f%%\n', 100 * trace(confusion) / sum(confusion(:)));
fprintf('\nConfusion matrix (rows = true identity, columns = predicted):\n');
fprintf('%-12s', '');
fprintf('%11s', model.labels{:});
fprintf('\n');
for c = 1:M
    fprintf('%-12s', model.labels{c});
    fprintf('%11d', confusion(c,:));
    fprintf('\n');
end
fprintf('\nPredictions written to %s\n', outputFile);
