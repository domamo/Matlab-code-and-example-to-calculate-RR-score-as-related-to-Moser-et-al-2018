
function [Median_RRscore,RRScores] = calc_RRscore(c1x2corrs,c2x1corrs,c1x2H2, c2x1H2, modes);
% This script calculates Mosers RR score, for canonical correlation
% If you use this script please cite the following paper:
% 2018: Moser DA, Doucet GE, Lee WH, et al. Multivariate Associations Among Behavioral, Clinical, and Multimodal Imaging Phenotypes in Patients With Psychosis. JAMA Psychiatry. 2018;75(4):386–395. doi:10.1001/jamapsychiatry.2017.4741
% that paper will also provide more information

% Emails can be directed to domamoser@gmail.com
% modes = number of modes/components you calculated
% Nperm is the number of permutations used for test sets
% c1x2corrs is the correlation between the variate of dataset 1 and each
% variable of dataset 2 when using all of the data
% c2x1corrs is the correlation between the variate of dataset 2 and each
% variable of dataset 1 when using all of the data
% c1x2H2 = For each tested component, there shoudl be a cell. Within cels this should have one line for each test set that was tested. Each value should be
% a correlation between the variate of dataset 1 within this test set and a variable of dataset 2 within this test set. 
% c2x1H2 = For each tested component, there should be a cell. Within cels this should have one line for each test set that was tested. Each value should be
% a correlation between the variate of dataset 2 within this test set and a variable of dataset 1 within this test set. 
% to note, this procedure slightly differs from those described in the papers, as it makes sure the RRscore fully takes "value flipping" among the
% weights into account.

% Licensing:
% This script is the intellctual property of Dominik A. Moser. The script comes without any kind of guarantee and its use is at every users own risk. License to use this file for public scientific purposes is free, provided above mentioned publication is cited.
% Any other use, including commercial use is only allowed with specific permission of the author.

% The example matrix provided in "example_RRscore.mat" contains the correlations of a dataset with 100
%permutations and 2 modes/components
Nperm = size(c1x2H2{1},1);

for mod=1:modes
  
    %%%%this whole next part is only here to makes sure flipped variables are
    %%%%not a problem
    for jj=1:Nperm
        c1x2H2perm(jj) = corr(c1x2corrs{mod},c1x2H2{mod}(jj,:)'); %these correlations will not be retained, they are only here to use as an indicator for whether to flip correlations
        c2x1H2perm(jj) = corr(c2x1corrs{mod},c2x1H2{mod}(jj,:)');
        if c2x1H2perm(jj)<0 %change if the general dataset is in the opposite direction of the test-set
            for ccc = 1:size(c2x1H2{mod},2);  %this part makes sure that directionality is not used the wrong way
                c2x1H2{mod}(jj,ccc) =  c2x1H2{mod}(jj,ccc)*-1;
            end
        end
        if c1x2H2perm(jj)<0 %change if the general dataset is in the opposite direction of the test-set
            for ccc = 1:size(c1x2H2{mod},2);
                c1x2H2{mod}(jj,ccc) =  c1x2H2{mod}(jj,ccc)*-1;
            end
        end
    end
    %%%%%%%%%%%%%%%
    c1x2H2Mean{mod,1}(:,1) = mean(c1x2H2{mod})';
    c2x1H2Mean{mod,1}(:,1) = mean(c2x1H2{mod})';
    for i=1:Nperm
        RRH2c1x2(i,mod)=corr(c1x2H2Mean{mod,1}(:,1),c1x2H2{mod}(i,:)'); %This calculates the first half of the RRscore
        RRH2c2x1(i,mod)=corr(c2x1H2Mean{mod,1}(:,1),c2x1H2{mod}(i,:)'); %This calculates the second half of the RRscore
        RRH2(i,mod)=mean([abs(RRH2c1x2(i,mod)),abs(RRH2c2x1(i,mod))]);
   end
end
RRScores = RRH2;
Median_RRscore = median(RRH2);