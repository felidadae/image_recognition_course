function perms = generate_subsets(v, K = 2)
	if K==2
		perms = generate_pairs(v,K);
	else
		N = size(v,2);
		N_perm = factorial(N)/factorial(K)/factorial(N-K);
		perms = zeros(N_perm, K);
	
		k=1;
		for i = 1:N
			v_e = v;
			v_e(i) = [];
		
			subperm = generate_subsets(v_e, K-1);
			perms(k:k+size(subperm,1)-1, 2:end) = subperm;
			perms(k:k+size(subperm,1)-1,1) = i;
			k += size(subperm,1);
		end
	end
end