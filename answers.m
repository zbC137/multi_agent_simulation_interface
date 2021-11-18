function [D,  A] = answers(value, items)

if strcmp(value, items{2})
    D = diag([4,4,4,4,4]);
    A = zeros(5,5)+1-eye(5);
elseif strcmp(value, items{3})
    D = diag([1,1,4,1,1]);
    A = [0, 0, 1, 0, 0
             0, 0, 1, 0, 0
             1, 1, 0, 1, 1
             0, 0, 1, 0, 0
             0 ,0 ,1, 0 ,0];
elseif strcmp(value, items{4})
    D = diag([2,2,2,1,1]);
    A = [0, 1, 0, 0, 1
             1, 0, 1, 0, 0
             0, 1, 0, 1, 0
             0, 0, 1, 0, 0
             1, 0, 0, 0, 0];
elseif strcmp(value, items{5})
    D = diag([1, 1, 3, 2, 1]);
    A = [0, 0, 1, 0, 0
             0, 0, 1, 0, 0
             1, 1, 0, 1, 0
             0, 0, 1, 0, 1
             0, 0, 0, 1, 0];
elseif strcmp(value, items{6})
    D = diag([2, 2, 2, 2, 2]);
    A = [0, 1, 1, 0, 0
             0, 0, 1, 1, 0
             0, 0, 0, 1, 1
             1, 0, 0, 0, 1
             1, 1, 0, 0, 0];
    A = A';
end

end

