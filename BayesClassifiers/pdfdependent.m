function probs = pdfdependent(set, model)
% Computes class dependent probability density values
%
% set - samples to compute pdf for (without labels!)

	N = rows(set);
	D = columns(set);
	C = rows(model.mu); %number of classes
	probs = ones(N, C);

	for icl = 1:C
		diff = set - repmat(model.mu(icl, :), N, 1);
		for iobject = 1:N
			probs(iobject, icl) = ...
				model.multiplier(icl)*exp(-diff(iobject,:) ...
					* model.invsigma(:,:,icl) ...
					* diff(iobject, :)'*0.5);
		end
	end