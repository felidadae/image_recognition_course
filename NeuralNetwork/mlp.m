function [cost, l_pred_idx] = learnMLP(v,w,  x,d,  g,o,K)
	N_y = columns(v);
	N_z = columns(w);

	y = [g([x 1] * V) 1];
	z = y * w;

	delta_z = (d - z) .* 0.5 .* (1 - z.^2);
	delta_y = ((w * delta_z')')(1:(rows(v)-1);

	w += K * y' * delta_z;
	v += K * x' * delta_y;

	z = classifyMLP(v,w, x, g,o);
	cost = cost(z, d);
	[_,l_pred] = max(z);

function cost = cost(z, d)
	return (z - d) .^2;

function z = classifyMLP(v,w, x, g,o)
	z = (o ( [g([x 1] * v) 1] * w ));

	