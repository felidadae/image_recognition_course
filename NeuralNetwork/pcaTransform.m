function [pcaSet] = pcaTransform(tvec, mu, trmx)
% tvec - matrix containing vectors to be transformed
% mu - mean value of the training set
% trmx - pca transformation matrix
% pcaSet -  outpu set transforrmed to PCA  space

pcaSet = tvec - repmat(mu, size(tvec,1), 1);

% Below is low-memory version
% I had to use it due to memory allocation error under Windows
% tic;
% pcaSet = zeros(size(tvec));
% for i=1:size(tvec,1)
  % pcaSet(i,:) = tvec(i,:) - mu;
% end
% toc

pcaSet = pcaSet * trmx;
