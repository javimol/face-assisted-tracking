function [ranking, scores, distances] = classifyFace(model, img)
%CLASSIFYFACE Rank gallery identities by similarity to a face image.
%
%   [ranking, scores, distances] = classifyFace(model, img)
%     ranking   - 1xM gallery indices, most likely identity first
%                 (model.labels{ranking(1)} is the predicted identity)
%     scores    - 1xM pseudo-probabilities aligned with ranking, computed
%                 as normalized inverse squared distances (they sum to 1)
%     distances - 1xM Euclidean distance in face space to each gallery
%                 face, in gallery order
%
%   img may be an image matrix or a path to an image file.

w = projectFace(model, img);

M = size(model.weights, 2);
distances = sqrt(sum((model.weights - repmat(w, 1, M)).^2, 1));

[sorted, ranking] = sort(distances, 'ascend');
sorted = max(sorted, 1e-6);   % avoid dividing by zero on exact matches
scores = (1 ./ sorted.^2) / sum(1 ./ sorted.^2);
end
