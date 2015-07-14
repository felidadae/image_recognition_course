function pairs = generate_pairs(v, l_el = 2)
	N = size(v,2);
	pairs = zeros(N*(N-1)/2, 2);
	
	k=1
	for i = 1:N
		for j = i+1:N
			pairs(k,:) = [v(i), v(j)];
			k+=1;
		end
	end 
end