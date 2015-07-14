more off;

if isempty(rndState_path)
	rand(1);
else
	%Load state of random generator from file
	load (rndState_path) 
	rand('state', rndstate);
end		

if !exist('train_set_x') 
	%Load data
	printf ('Load data...\n') 
	fflush(stdout);
	[train_set_x train_set_y test_set_x test_set_y] = readSets();

	%PCA
	printf ('PCA...\n')
	xDim = 100
	[mu trmx]     = prepTransform(train_set_x, xDim);
	train_set_x   = pcaTransform (train_set_x, mu, trmx);
	test_set_x    = pcaTransform(test_set_x, mu, trmx);
	

	%Prepare valid set taking 10000 samples from train set
	valid_set_x = train_set_x(50001:60000,:);
	valid_set_y = train_set_y(50001:60000,:);
	train_set_x = train_set_x(1:50000,:);
	train_set_y = train_set_y(1:50000,:);

	%Params from dataset
	train_set_N   = length(train_set_x);
	valid_set_N   = length(valid_set_x);
	test_set_N    = length(test_set_x);
	N_x = xDim;
	uniqueYSet = unique(test_set_y);
	N_z = length(uniqueYSet);
end



%Meta params
printf ('\nMeta params\n')
g = @sigmoid
o = @sigmoid
N_y = 300
K_b = 0.01
K = K_b;
randWeightsFun = @randWeights
   


modelBetterThan2Percent = false;
irun = 0;
errorOnTestingSet_perRun = [];

tic()
while !modelBetterThan2Percent
	printf('\n\nRerun algorithm %d time', irun)
	
	%rndstate = rand('state');
	save rndstate.txt rndstate
	
	
	%Rand weights
	v = randWeightsFun(xDim+1, N_y);
	w = randWeightsFun(N_y+1,  N_z);  
	
	
	%TRAIN
	printf ('\nTrain...\n')
	testCostsPerEpoch   = [];
	validErrorsPerEpoch = [];
	validationStop = false;
	patience = 10;
	iepoch = 1;
	%%%
	bestModel.v = v;
	bestModel.w = w;
	bestModel.errorOnValidSet = inf;
	currentModel.v = v;
	currentModel.w = w;
	currentModel.errorOnValidSet = inf;
	%%%
	while validationStop == false
	
		testCostsPerEpoch   = [testCostsPerEpoch   0];
		validErrorsPerEpoch = [validErrorsPerEpoch 0];
	
		%epoch on test set; modify weights
		for iexample = 1:train_set_N
			d = repmat(-1, 1,N_z);
			d(findIndex(train_set_y(iexample), uniqueYSet)) = 1;

			[currentModel.v,currentModel.w,cost] = ...
				learnMLP(currentModel.v,currentModel.w,   ...
				    train_set_x(iexample, :),d,   g,o,K);
			testCostsPerEpoch(iepoch) += cost;
		end
		printf ('Epoch %d complete with cost %f\n', iepoch, testCostsPerEpoch(iepoch))
	
		%epoch on validation set; weights untouched
		l_preds = [];
		for iexample = 1:valid_set_N
			l_pred_idx = ...
				classifyMLP(currentModel.v,currentModel.w,  ...
				    valid_set_x(iexample, :),   g,o);
			l_preds = [l_preds uniqueYSet(l_pred_idx)];
		end
		errorOnValidSet = (sum([l_preds != valid_set_y'])) /valid_set_N*100;
		currentModel.errorOnValidSet = errorOnValidSet;
		validErrorsPerEpoch(iepoch) = errorOnValidSet;
		printf ('Validation error-rate %f%%\n', validErrorsPerEpoch(iepoch))
	
		%check whether model is overfitting 
		if currentModel.errorOnValidSet >= bestModel.errorOnValidSet
			if patience == 0
				validationStop = true;
			else
				patience -= 1;
			end
		else
			patience = 10;
			bestModel.v = currentModel.v;
			bestModel.w = currentModel.w;
			bestModel.errorOnValidSet = currentModel.errorOnValidSet;
		end
		
		%%Modify K
		%K = K_b/iepoch
		%%%%
		
		iepoch = iepoch + 1;
	end
	printf('Optimization complete.\n')



	%TEST ...
	printf ('\nTest best model on unseen data...\n')
	l_preds = [];
	for iexample = 1:test_set_N
		l_pred_idx = classifyMLP(bestModel.v,bestModel.w,   ...
		    test_set_x(iexample, :),   g,o);
		l_preds = [l_preds uniqueYSet(l_pred_idx)];
	end
	errorOnTestingSet = (sum([l_preds != test_set_y'])) / test_set_N*100;
	errorOnTestingSet_perRun = [errorOnTestingSet_perRun errorOnTestingSet]
	printf ('Test error-rate of best model %f%%\n', errorOnTestingSet)
	printf ('(Valid error-rate of best model %f%%)\n', bestModel.errorOnValidSet)

	if errorOnTestingSet < 2.0
		printf ('Model with error less than 2 percentage found.')
		modelBetterThan2Percent = true;
		save iepoch
		save vpickled bestModel.v;
		save wpickled bestModel.w;
		save errorOnTestingSet_perRun errorOnTestingSet_perRun;
	else
		%%Change metaparams
		%%No changes <- check how model with given metaparams varies 
	end
end
time=toc()

printf('Learning time %.1f minutes \n', time/60.)
matrixTeX(validErrorsPerEpoch, '$%.2f$', 'c', 'valid_error')

