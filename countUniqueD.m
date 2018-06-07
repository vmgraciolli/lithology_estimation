function [ out ] = countUniqueD( input )
%COUNTUNIQUE returns a matrix with the number of occurences of each element
%            in a vector
%   input: input vector

uniques = unique(input);

out = [uniques(1), size(input((uniques(1) == input(:,:))),1)];

for i = 2:size(uniques,1)
   
    out = [out; uniques(i), size(input((uniques(i) == input(:,:))),1)];
    
end

end

