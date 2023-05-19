function output = madm_test(test_data,model,model2)

model.nor.dat = mean_and_std(test_data,'true');
test_data = normalize_data(test_data,model.nor.dat);

output.dis = model.b * ones(size(test_data,1),1);
Kernel = (test_data*model.sup.X'+1).^2;

 output.dis = sum((model.sup.s.*model.sup.alp)'.*Kernel,2)+output.dis;
end