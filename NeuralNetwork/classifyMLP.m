function l_pred = classifyMLP(v,w, x, g,o)
	z = (o ( [g([x 1] * v) 1] * w ));
	[_,l_pred] = max(z);

