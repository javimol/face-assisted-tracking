function model = buildEigenfaces(galleryDir, cfg)
%BUILDEIGENFACES Build a PCA (eigenfaces) face space from a gallery folder.
%
%   model = buildEigenfaces(galleryDir) reads every image in galleryDir
%   (normally one per known identity), normalizes them and computes the
%   eigenfaces that span the gallery. The file name of each image, without
%   extension, is used as the identity label.
%
%   model = buildEigenfaces(galleryDir, cfg) uses custom parameters
%   (see eigenfaceConfig).
%
%   The returned struct contains:
%     labels      - 1xM cell array of identity names
%     files       - 1xM cell array of gallery image paths
%     images      - NxM normalized gallery images (N = pixels per face)
%     meanFace    - Nx1 mean face
%     eigenfaces  - NxK orthonormal eigenfaces, sorted by eigenvalue
%     eigenvalues - 1xK eigenvalues, descending
%     weights     - KxM projection of each gallery face onto the eigenfaces
%     cfg         - parameters used
%
%   Because the gallery usually holds only a handful of images (M << N),
%   the eigenvectors of the NxN covariance A*A' are obtained from the much
%   smaller MxM matrix A'*A (Turk & Pentland's trick): if A'*A*v = d*v,
%   then A*v is an eigenvector of A*A' with the same eigenvalue d.

if nargin < 2
    cfg = eigenfaceConfig();
end

files = listImages(galleryDir, cfg);
M = numel(files);
N = prod(cfg.imageSize);

S = zeros(N, M);
labels = cell(1, M);
for i = 1:M
    S(:,i) = preprocessFace(imread(files{i}), cfg);
    [~, labels{i}] = fileparts(files{i});
end

meanFace = mean(S, 2);
A = S - repmat(meanFace, 1, M);

% Eigen-decomposition of the small MxM surrogate matrix.
[V, D] = eig(A' * A);
d = diag(D)';
keep = d > cfg.minEigVal * max(d);   % centering leaves at most M-1 non-null
[d, order] = sort(d(keep), 'descend');
V = V(:, keep);
V = V(:, order);

% Map back to image space and normalize each eigenface to unit length.
U = A * V;
U = U ./ repmat(sqrt(sum(U.^2, 1)), N, 1);

model.labels      = labels;
model.files       = files;
model.images      = S;
model.meanFace    = meanFace;
model.eigenfaces  = U;
model.eigenvalues = d;
model.weights     = U' * A;
model.cfg         = cfg;
end
