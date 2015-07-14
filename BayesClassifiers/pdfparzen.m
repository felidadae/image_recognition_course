function probs = pdfparzen(set, model)
% Computes class dependent probability density values
%
% set - samples to compute pdf for (without labels!)
% model - trained model on bayestrain in "parzen" mode

	N = rows(set);
	D = columns(set);
	C = model.C; 
	h1 = model.h1;
	
	probs = ones(N, C);
	for ic = 1:C
		for is = 1:N
			m_s_ic = model.samples{ic};
			N_m_s_ic = size(model.samples{ic}, 1);
			
			diff = repmat(set(is,:), N_m_s_ic, 1) - m_s_ic;
			h_n = h1 / sqrt(N_m_s_ic);
		
			window_arg = diff / h_n;
			window = (1/sqrt(2*pi)) * exp(-window_arg.^2/2);
		
			probs(is, ic) = mean(prod( (1/h_n) * window, 2 ), 1);
		end
	end	
end