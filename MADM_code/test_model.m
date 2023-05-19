function [a output] = test_model(test_data,test_labels,model,model2,v)
parameters = madm_parameter();
parameters.v = v;
output = madm_test(test_data,model,model2);
testsize = length(test_labels);
a = ones(testsize,1);
a(find(output.dis<0))=2;
end