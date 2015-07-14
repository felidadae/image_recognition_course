function index = findIndex(yValue, yu)
	for i = 1:length(yu)
		if yu(i) == yValue
			index = i;
		end
	end
end