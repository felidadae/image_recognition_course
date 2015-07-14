function probs = pdfindependent(set, model)
% Computes class dependent probability density values 
% assuming independent features and with parameters given
% in model
% (p(x|ci)) = p(x1|ci)*p(x2|ci)*...
%
% output: probs - a row contain data for a x object, column i is p(x|ci)
%
% tset - samples to compute pdf for (without labels!)
	
	N = rows(set);
	D = columns(set);
	C = rows(model.mu); %number of classes
	probs = ones(N, C);
	
	for iclass = 1:C
		for ifeat = 1:D
			probs(:,iclass) .*= normpdf (set(:,ifeat), model.mu(iclass, ifeat), model.sigma(iclass, ifeat));
		end
	end
end
