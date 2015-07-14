function weights = randWeights(N_h_prev, N_h)
	weights = (rand(N_h_prev,N_h)-0.5)*2*sqrt(6)/sqrt(N_h_prev+N_h);
	weights(N_h_prev, :) = 0;