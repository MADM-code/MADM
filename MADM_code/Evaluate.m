 function [precision recall f_measure accuracy] = Evaluate(ACTUAL,PREDICTED,pos_class)
idx = (ACTUAL()==pos_class);

p = length(ACTUAL(idx));
n = length(ACTUAL(~idx));
N = p+n;

tp = sum(ACTUAL(idx)==PREDICTED(idx));
tn = sum(ACTUAL(~idx)==PREDICTED(~idx));
fp = n-tn;
fn = p-tp;

tp_rate = tp/p;
tn_rate = tn/n;


%sensitivity = tp_rate;
%specificity = tn_rate;
precision = tp/(tp+fp);
recall = tp/(tp+fn);
f_measure = 2*(precision*recall)/(precision + recall);
accuracy = (tp+tn)/N;
%gmean = sqrt(precision*recall);

% ind_pos = (ACTUAL==1);
% ind_neg = (ACTUAL~=1);
% pos_true = sum(ACTUAL(ind_pos)==PREDICTED(ind_pos))/length(ind_pos);
% pos_neg = sum(ACTUAL(ind_neg)==PREDICTED(ind_neg))/length(ind_neg);
% 
% UAR = (pos_true+pos_neg)/2;



EVAL = [precision recall f_measure accuracy];
