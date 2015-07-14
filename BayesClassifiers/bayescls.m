
function bdec = bayescls(test_set, model, apriori)
%Bayes classifier
% tset    - matrix of samples to be classified (sample is a row of the matrix)
% model   - parameters for the pdfunc ( computed on the training set)
% apriori - row vector of a priori probabilities

	probs = model.funcHandle(test_set, model);
	
	if nargin >= 3
		probs .*=repmat(apriori, rows(probs), 1);
	end

	[v iv] = max(probs, [], 2);
	bdec = model.labels(iv);
end