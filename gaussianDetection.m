function [ accuracy, results ] = gaussianDetection( training, validation, multivar, usebias, minsamples, facies )
%GAUSSIANDETECTION Estimates lithology based on log data
%   training: training set, in the form of a matrix of NxM dimensions,
%   where N is the number of samples, and M is the number of logs + 1. Each
%   column corresponds to a single log, the last column contains the
%   lithology labels
%   validation: validation set, in the form of a matrix of NxM dimensions,
%   where N is the number of samples, and M is the number of logs + 1. Each
%   column corresponds to a single log, the last column contains the
%   lithology labels
%   multivar: whether or not to use the correlation between logs. Use 1 to
%   run the multivariate version, anything else to run the univariate
%   version
%   usebias: whether or not to use log bias. Use 1 to use the bias in the
%   calculation, anything else to disregard it.
%   minsamples: disregard lithologies with less samples than this number
%   facies: column containing the facies segmentation. Positions containing
%   the same value correspond to the same facies.


columns = size(training,2);

lithos = countUniqueD(training(:,columns));

for i=1:size(lithos,1)
    if lithos(i,2) < minsamples
        training(training(:,end) == lithos(i,1),:) = [];
    end
end

lithos = [lithos, lithos(:,2)./sum(lithos(:,2))*100];

lithomean = zeros(size(lithos,1), columns-1);
lithocov = zeros(columns-1, columns-1, size(lithos,1));

for i = 1:size(lithos,1)
    
    lithodata = training(training(:,columns) == lithos(i,1),1:columns-1);
    lithomean(i,:) = nanmean(lithodata);
    covm = nancov(lithodata,'pairwise');
    lithocov(:,:,i) = covm;
    
end

rows = size(validation,1);

results = zeros(rows, size(lithos,1) + 2);
results(:,1) = validation(:,columns);

if multivar == 1
    for i = 1:size(lithos,1)
        mvnd = mvnpdf(validation(:,1:columns-1),lithomean(i,:), lithocov(:,:,i));
        if usebias == 1
            results(:,2+i) = mvnd*lithos(i,3);
        else
            results(:,2+i) = mvnd;
        end
    end
else
    for i = 1:size(lithos,1)
        for j=1:size(lithomean,2)
            mvnd = mvnpdf(validation(:,j),lithomean(i,j), lithocov(j,j,i));
            acc = acc + mvnd;
        end
        if usebias == 1
            results(:,2+i) = acc*lithos(i,3);
        else
            results(:,2+i) = acc;
        end
    end
end

results(:,2) = declareLitho(results(:,3:end), facies, lithos, 0);
resfil = results(ismember(results(:,1),lithos(:,1)),:);

negs = resfil(:,1) - resfil(:,2);
accuracy = size(negs(negs(:,:)==0,:),1)/size(negs,1);

end

