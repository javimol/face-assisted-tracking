function cfg = eigenfaceConfig()
%EIGENFACECONFIG Default parameters shared by every stage of the pipeline.
%
%   cfg = eigenfaceConfig() returns a struct with:
%     imageSize   - [rows cols] every face is resized to (QCIF, 176x144)
%     targetMean  - grey level every face is shifted to during normalization
%     targetStd   - standard deviation every face is scaled to
%     minEigVal   - eigenvalues below this fraction of the largest one are
%                   considered null and dropped
%     extensions  - image file extensions accepted when scanning folders

cfg.imageSize  = [176 144];
cfg.targetMean = 100;
cfg.targetStd  = 80;
cfg.minEigVal  = 1e-4;
cfg.extensions = {'.png'};
end
