function matrixTeX(A, frow, alignn, title)
    [m,n] = size(A);

    printf('\n\\begin{tabular}{%s}\n', alignn);
    printf('    \\hline')
    printf('\n    %s \\\\\n',title)
    printf('    \\hline\n')

    for i = 1:m
        printf('    ')
        printf(frow, A(i,:));
        printf('\\\\\n')
    end
    
    printf('    \\hline\n\\end{tabular}\n\n');
end
