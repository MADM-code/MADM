function [alp, obj, model2] = solve_ocsvm(train_data,train_labels,parameters,yyKeta,alp)
num_data = size(train_data,1);
switch lower(parameters.opt)
    case 'libsvm'
        alp = zeros(num_data,1);
%         model2 = svmtrain(train_labels,[(1:1:num_data)' yyKeta], sprintf('-q -s 2 -t 4 -e %g -n 0.01',parameters.tau));
%         model2 = svmtrain(train_labels,[(1:1:num_data)' yyKeta], sprintf('-q -s 2 -t 4 -e %g','-n',parameters.v,parameters.tau));
        model2 = svmtrain(train_labels,[(1:1:num_data)' yyKeta], sprintf('-q -s 2 -t 4 -e %g -n 0.05',parameters.tau));
        alp(model2.SVs) = abs(model2.sv_coef);
end
% alp(alp < 1/(parameters.v*num_data)*parameters.eps) = 0;
% alp(alp > 1/(parameters.v*num_data)*(1-parameters.eps)) = 1/(parameters.v*num_data);

alp(alp < parameters.v*parameters.eps) = 0;
alp(alp > parameters.v*(1-parameters.eps)) = parameters.v;

% obj = 0.5*alp'*yyKeta*alp;
obj = -0.5*alp'*yyKeta*alp;
end