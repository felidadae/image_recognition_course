more off;

%Testing
%modes = {'independent', 'dependent', 'parzen'};
%testSets = {smallTest, test};
%testSetsVariables = { [1 2 4 5], [1:columns(train)] }
%for iMode = 1:3
%	for iTS = 1:2
%		bModel = bayestrain (train(:, testSetsVariables{iTS}), modes{iMode});
%		result = bayescls (testSets{iTS}(:, 2:end), bModel);
%		rate  = sum(testSets{iTS}(:,1) == result)/rows(result)*100;
%		printf('Mode: %s, trainSetIndex: %d -> Rate = %f\n', modes{1}, iTS, rate)
%	end
%end


modes = {'independent', 'dependent', 'parzen'};
arr_sum = []
if experiment1 == true
    per = nchoosek([2:8], 2);
    for i=1:size(per,1)
        error_rate_m = zeros(1,3);
        for imode=1:3
            bmode = modes{imode};
            train_t = train(:, [1,per(i,:)]);
            test_t  = test (:, [1,per(i,:)]);

            bModel = bayestrain (train_t, bmode, 0.0007);
            result = bayescls   (test_t(:, 2:end), bModel,0.0007);
            error_rate  = 100 - sum(test_t(:,1) == result)/rows(result)*100;
            printf('Feature <- [')
            printf('%d', per(i,1))
            printf(', %d', per(i,2:end))
            printf('], Mode <- %s, Error rate <- %f%%\n', bmode, error_rate)
            
            error_rate_m(imode) = error_rate;
        end
        arr_sum = [arr_sum; [per(i,1), per(i,2), error_rate_m]];
    end
        
    %[d1,d2] = sort(arr_sum_part(:,4));
    %arr_sum_part=arr_sum_part(d2,:);
    
    matrixTeX(arr_sum, '($%d$, $%d$) & $%.2f\\%%$ & $%.2f\\%%$ & $%.2f\\%%$', ...
        'clll', '$cechy$ & błąd naiwny & błąd wielowym & błąd parzen')
end

if experiment2 == true
    i=1;
    imode = 3;
    per = [3,4,5];
    h1_ = 0.001:0.01:0.1;

    error_rate = [];

    for i = 1:size(h1_, 2)
        h1 = h1_(i);
        bmode = modes{imode};
        train_t = train(:, [1,per]);
        test_t  = test (:, [1,per]);

        bModel = bayestrain (train_t, bmode, h1);
        result = bayescls   (test_t(:, 2:end), bModel);
        error_rate = [ error_rate, 100 - sum(test_t(:,1) == result)/rows(result)*100];

        printf('h1 <- %f, Error rate <- %f%%\n', h1, error_rate(end))
    end

    %make plots
    %plot(error_rate, 'or')
    %xbounds = xlim()
    %set(gca, 'xtick', xbounds(1):1:xbounds(2))
    arr_sum = [h1_', error_rate']
    matrixTeX(arr_sum, '$%.4f$ & $%.2f\\%%$', ...
        'clll', 'h1 & błąd parzen')
end

if experiment3 == true
	%reduce train set
    t = [1,0.75,0.5,0.25]
    
    arr_sum = []

    per = nchoosek([3:4], 2);
    for ireduce = 1:4
        
        %Reduce train set
        train_t = [];
        for i = 1:4
            bool_cl = train(:,1)==i;

            part = train(bool_cl,:);
            size(part);
            part = part(1:size(part,1).*t(ireduce),:);

            train_t = [train_t; part];
        end
        
        
        for i=1:size(per,1)
            error_rate_m = ones(1,3);
            for imode=1:3
                bmode = modes{imode};
                
                %Choose features
                train_t_t = train_t(:, [1,per(i,:)]);
                test_t  = test (:, [1,per(i,:)]);

                bModel = bayestrain (train_t_t, bmode, 0.0007);
                result = bayescls   (test_t(:, 2:end), bModel);
                error_rate  = 100 - sum(test_t(:,1) == result)/rows(result)*100;
                printf('Feature <- [')
                printf('%d', per(i,1))
                printf(', %d', per(i,2:end))
                printf('], Mode <- %s, Error rate <- %f%%\n', bmode, error_rate)
                error_rate_m(imode) = error_rate;
            end
            printf('\n')
        end
        
        arr_sum = [arr_sum; [t(ireduce), error_rate_m]];
    end
    matrixTeX(arr_sum, '$%.2f$ & $%.2f\\%%$ & $%.2f\\%%$ & $%.2f\\%%$', ...
        'clll', 'wielkość zbioru & błąd naiwny & błąd wielowym & błąd parzen')
end

if experiment4 == true
    arr_sum = []
    
	%prepare dataset with given apriori    
    apriori = [0.5;1;1;0.5];
    train_t = [];
    for i = 1:size(apriori, 1)
        bool_cl = train(:,1)==i;

        part = train(bool_cl,:);
        size(part);
        part = part(1:size(part,1)*apriori(i),:);

        train_t = [train_t; part];
    end
    test_t = [];
    for i = 1:size(apriori, 1)
        bool_cl = test(:,1)==i;

        part = test(bool_cl,:);
        part = part(1:size(part,1)*apriori(i),:);

        test_t = [test_t; part];
    end

    per = nchoosek([2:8], 2);
    
    for i=1:size(per,1)
        error_rate_m = ones(1,3);
        for imode=1:3
            bmode = modes{imode};
            train_t_t = train_t(:, [1,per(i,:)]);
            test_t_t  = test_t (:, [1,per(i,:)]);

            bModel = bayestrain (train_t_t, bmode, 0.0007);
            result = bayescls   (test_t_t(:, 2:end), bModel, apriori');
            error_rate  = 100 - sum(test_t(:,1) == result)/rows(result)*100;
            printf('Feature <- [')
            printf('%d', per(i,1))
            printf(', %d', per(i,2:end))
            printf('], Mode <- %s, Error rate <- %f%%\n', bmode, error_rate)
            error_rate_m(imode) = error_rate;
        end
        printf('\n')
        
        arr_sum = [arr_sum; [per(i,1), per(i,2), error_rate_m]];
    end
    
    
    matrixTeX(arr_sum, '($%d$, $%d$) & $%.2f\\%%$ & $%.2f\\%%$ & $%.2f\\%%$', ...
        'clll', '$cechy$ & błąd naiwny & błąd wielowym & błąd parzen')
end

if experiment5 == true
    result = [];
    for is = 1: size(test, 1)
        result = [result; cls1nn(train, test(is,2:end))];
    end
    
    error_rate  = 100 - sum(test(:,1) == result)/rows(result)*100;
    printf('Error rate <- %f%%\n', error_rate)
end


