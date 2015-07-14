function y = sigmoid(x)
	y = 2./(1+exp(-1 .* x))-1;