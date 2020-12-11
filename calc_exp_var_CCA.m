%if using this file, please cite Moser et al 2021, Reduced network integration in default mode and executive networks is associated with social and personal optimism biases.
% This file calculates explained variance in canonical correlation analysis
%c = canonical correlation values
%X1 = dataset 1
% X2 = dataset 2
% c1: variate/overall score of dataset 1
% c2 variate/overall score of dataset 2
% expDSX1 = variance of dataset 1 explained by the variate of datset 2
% expDSX2 = variance of dataset 2 explained by the variate of datset 1
% expVariate: how mucheach dataset explains of the other, if one were to
% assume that variates are representations of the entire dataset wherefore
% the variance explained in previous datasets were
% Emails can be directed to domamoser@gmail.com
% Licensing:
% This script is the intellctual property of Dominik A. Moser. The script comes without any kind of guarantee and its use is at every users own risk. License to use this file for public scientific purposes is free, provided above mentioned publication is cited.
% Any other use, including commercial use is only allowed with specific permission of the author.

clear Z expVariate expDSX1 expDSX2 expDSX expDSX1cum expDSX2cum expDSXcum c1X1corrExp c2X2corrExp



for Z= 1:size(c,2)
expDSX1(Z) = mean(corr(c2(:,Z),X1).^2);
expDSX2(Z) = mean(corr(c1(:,Z),X2).^2);
expVariate(Z) = c(Z)^2;
if Z > 1
expDSX1(Z) = (1-sum(expDSX1(1:Z-1)))* expDSX1(Z);
expDSX2(Z) = (1-sum(expDSX2(1:Z-1)))* expDSX2(Z);
expVariate(Z)=(1-sum(expVariate(1:Z-1)))* expVariate(Z);
end
expDSX1cum(Z) = sum(expDSX1(1:Z));
expDSX2cum(Z) = sum(expDSX2(1:Z));
end
expDSX = (expDSX1+expDSX2)/2;
