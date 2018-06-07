function [ faciescol ] = splitFacies( input, short, long, weight, threshold, spread )
%SPLITFACIES Segments a log using a moving means algorithm
%   input: matrix of NxM dimensions,where N is the number of samples, and M
%   is the number of logs, each column corresponds to a single log
%   short: short window size
%   long: long window size
%   weight: log weight vector
%   threshold: weight threshold for break detection
%   spread: agreement window size

    shmean = movmean(input,short,1);
    lomean = movmean(input,long,1);
    
    diff = lomean - shmean;
    
    binvec = diff./abs(diff);
    
    faciescol = makeChangeVec(binvec, weight, threshold, spread);
    
end

