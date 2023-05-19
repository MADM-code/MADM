function [model, model2] = aocsvm_train(train_data,train_labels,parameters)
[num_data,dim] = size(train_data);

%% 归一化
R_nan = ismissing(train_data);
R_nonan = logical(ones(num_data,dim)-R_nan);
train_data(R_nan) = 0;
model.nor.dat = mean_and_std(train_data,'true');
train_data = normalize_data(train_data,model.nor.dat);
train_data(R_nan) = 0;

s_old = ones(num_data,1);
model.s = 1./s_old;
% Kernel = train_data*train_data'; %linear
Kernel = (train_data*train_data'+1).^2; %ploy
yyKeta = (model.s*model.s').*(train_labels*train_labels').*Kernel;

alpha = zeros(num_data,1);
[alp, obj, model2] = solve_ocsvm(train_data,train_labels,parameters,yyKeta,alpha);
model.obj = obj;
model.alp = alp;
model.w = sum(model.alp.*train_data.*model.s)';
p = 0;
while p<300
    oldobj = obj;
    s_new = zeros(num_data,1);
    for i = 1:num_data
        s_new(i,1) = 1./(norm(R_nonan(i,:)'.*model.w)/norm(model.w));
    end
    model.s = s_new;
%     Kernel = train_data*train_data';
    yyKeta = (model.s*model.s').*(train_labels*train_labels').*Kernel;
    alpha = zeros(num_data,1);
    [alp, obj, model2] = solve_ocsvm(train_data,train_labels,parameters,yyKeta,alpha);
    model.obj = [model.obj,obj];
    model.alp = alp;
    model.w = sum(model.alp.*train_data.*model.s)';
    if abs(obj-oldobj) <= parameters.eps
        for i = 1:num_data
            model.s(i,1) =1./(norm(R_nonan(i,:)'.*model.w)/norm(model.w));
        end
        break;
    end
    for i = 1:num_data
        model.s(i,1) = 1./(norm(R_nonan(i,:)'.*model.w)/norm(model.w));
    end
    yyKeta = (model.s*model.s').*(train_labels*train_labels').*Kernel;
    p=p+1;
end
sup = find(model.alp~=0);
%sup = find(model.alp~=0);
train_index = (1:num_data)';
model.sup.ind = train_index(sup);
model.sup.X = train_data(sup,:);
model.sup.y = train_labels(sup);
model.sup.alp = model.alp(sup);
model.sup.s = model.s(sup);

sup = find(model.alp~=0);
act = find(model.alp~=0 & model.alp <1./(parameters.v*num_data));
% act = find(model.alp~=0 & model.alp <parameters.v);
if isempty(act) == 0
    model.b = mean(train_labels(act).*(1-yyKeta(act,sup)*model.alp(sup)));
else
    model.b = 0;
end
model.par = parameters;
end






