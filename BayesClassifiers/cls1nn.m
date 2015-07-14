function lab = cls1nn(ts, x)
	% 1-NN classifier
	% ts - training set (first column contains class label)
	% x - sample to be classified (without label!)
    %
	% return: lab - label of x
	[v iv] = min(sqrt (sum( [repmat(x, rows(ts), 1)-ts(:, 2:end)].^2, 2)));
	indexOfNearestNeighbour = iv;
	lab = ts(iv, 1);
end