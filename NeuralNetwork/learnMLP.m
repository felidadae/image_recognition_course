%% Oznaczenia zgodne z wykładem ROB

function [vn, wn, cost] = learnMLP(v,w,  x,d,  g,o, K)
	y = [g([x 1] * v) 1];
	z = o(y * w);

	delta_z = (d - z)           .* 0.5 .* (1 - z.^2);
	delta_y = ((w * delta_z')') .* 0.5 .* (1 - y.^2);
	delta_y = delta_y(1:columns(v));

	w += K *     y' * delta_z;
	v += K * [x 1]' * delta_y;

	%Cost after changing weights
	z = (o ( [g([x 1] * v) 1] * w ));
	cost = cost(d, z);

	vn = v;
	wn = w;

function cost = cost(d, z)
	cost = sum((d - z) .^2);
	
	


	



