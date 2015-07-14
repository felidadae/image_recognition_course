%Note: first column real class label

%Load data
load('test.txt')	%test
load('train.txt')	%train

%Clean data
train(186,:) = [];
train(640,:) = [];

%Prepare smaller test, train
s_train = train([1 50 150 200], [1 2 4]);
s_test	= test ([1 50 150 200], [1 2 4]);

experiment1=false
experiment2=false
experiment3=false
experiment4=false
experiment5=false

