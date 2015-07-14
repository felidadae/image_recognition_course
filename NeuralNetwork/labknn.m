function [labknn distknn] = labknn(trset, trlab, testset, k)
% labknn computes labels and distances to k nearest neighbours in the training set for all points 
% in the test set
% trset - training set points
% trlab - labels of the samples in the training set
% testset - test set points
% k - number of neighbours to be returned
% labknn - matrix containing labels of nearest neighbours in the training set
% distknn - matrix containing distances to the nearest neighbours in the training set

tic;
	labknn = zeros(size(testset, 1), k);
	distknn = zeros(size(testset, 1), k);
	for i=1:size(testset, 1)
		[res rid]= sort(sum((trset- repmat(testset(i,:), size(trset,1),1)).^2,2), 'ascend');
		labknn(i,:) = trlab(rid(1:k))';
	    distknn(i,:) = res(1:k)';
	end
toc
end 
