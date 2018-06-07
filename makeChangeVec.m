function [ out ] = makeChangeVec( input, weight, threshold, spread )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    lines = size(input, 1);
    cols = size(input, 2);
    out = zeros(lines + 1, 1);
    msum = out;
    
    shiftd = [input(1,:); input(:,:)];
    shiftu = [input(:,:); input(lines,:)];

    clear = sum((shiftd(:,:) ~= shiftu(:,:)) .* weight,2);
    clear(lines+1) = [];

    msum = movsum(clear, spread);
    
    clipsum = msum;
    
    clipsum(clipsum < threshold) = 0;
    
    [~,index] = findpeaks(clipsum);
    
    start = 1;
    facies = 1;
    
    for i = 1:size(index, 1)
       
        for j = start:index(i)
           
            out(j) = facies;
            
        end
        start = index(i) + 1;
        facies = facies + 1;
    end

end

