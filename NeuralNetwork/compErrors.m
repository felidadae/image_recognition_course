function [errors] = compErrors(confmx)
% Computes vector of recognition coeffitients: good, error and rejection.
% confmx - confusion matrix of the classification results
% errors - vector containing proper classifications, errors and reject decision coefficients
	total = sum(sum(confmx));
	% correct decisions are on the main diagonal
	errors(1) = trace(confmx) / total;
	% errors are on off the main diagonal
	errors(2) = (total - trace(confmx) - sum(confmx(:,end))) / total;
	% last column contains reject decisions
	errors(3) = sum(confmx(:,end)) / total;