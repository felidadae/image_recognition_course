
function model = bayestrain(train_set, pdmode, h1)
% Bayes training
% train_set - train_set data 
% pdmode - identifier of probability density computing method
%	allowed values are:
%		independent - assumes independence of features, 
%			where each feature has a normal distribution
%		dependent - multivariate normal distribution
%		parzen - pdf approximation with Parzen window

	N = rows(train_set);
	D = columns(train_set)-1;
	C = rows(unique(train_set(:,1)));

	model.labels = unique (train_set(:,1));
	model.name = pdmode;
	if 	   strcmpi 	(pdmode, 'independent')
		model.funcHandle = @pdfindependent;
		model.mu    = zeros(C, D);
		model.sigma = zeros(C, D);
		for icl=1:C
			bool_ifclIdx = train_set(:,1) == model.labels(icl);
			model.mu   (icl,:) = mean(train_set( bool_ifclIdx,  2:end ));
			model.sigma(icl,:) = std (train_set( bool_ifclIdx,  2:end ));
		end
	elseif strcmpi 	(pdmode, 'dependent')
		model.funcHandle = @pdfdependent;
		model.mu    		= zeros(C, D);
		model.multiplier 	= zeros(C, 1);
		model.sigma 		= zeros(D, D, C);
		model.invsigma 		= zeros(D, D, C);
		for icl = 1:C
			clIdx = train_set(:,1)==model.labels(icl);
			model.mu(icl,:) = mean(train_set(clIdx, 2:end));
			model.sigma		(:,:,icl) = cov(train_set(clIdx, 2:end));
			model.invsigma	(:,:,icl) = inv(model.sigma(:,:,icl));
			model.multiplier(icl) = 1 / sqrt (det(model.sigma(:,:,icl))*(2*pi)^columns(model.mu));
		end
	elseif strcmpi 	(pdmode, 'parzen')
		if nargin >= 3
			model.h1 = h1;
		else 
			model.h1 = 0.007;
		end
		model.C = C;
		model.funcHandle = @pdfparzen;
		model.samples = cell(rows(model.labels), 1);
		for icl=1:C
			clIdx = train_set(:,1) == model.labels(icl);
			model.samples{icl} = train_set(clIdx, 2:end);
		end
	end
end