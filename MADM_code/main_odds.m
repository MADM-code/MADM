clear all
clc
res_all = [];
addpath(genpath('H:\特征缺失的异常检测\MADM_code\data')); % The correct path for filling in the data is required here.
for data_num = 1:15
    
    get_dnames_odds;
    dnames = [dname];
    tot_data = load([dnames '.mat']); % 0-->normal 1-->outlier    
    data_only = tot_data.X;
    data_labels = tot_data.y;
    data_label = data_labels;
    
    count = 0;
    res.dname = [dname];
    data_label(data_labels == 0) = 1;
    data_label(data_labels ~= 0) = 2;
    normal_data = data_only(data_label==1,:);
    normal_data = cat(2,normal_data,ones(size(normal_data,1),1));
    outlier_data = data_only(data_label==2,:);
    outlier_data = cat(2,outlier_data,ones(size(outlier_data,1),1).*2);
    [num_data,dim] = size(normal_data);
    fold_run_pos = crossvalind('kfold',normal_data(1:num_data,dim-1),5);
    [num_data,dim] = size(outlier_data);
    fold_run_neg = crossvalind('kfold',outlier_data(1:num_data,dim-1),5);
    
    abs_rate = [0.1:0.1:0.9];
    tot_run = 5; tot_fold = 5;
    optmodf = {};
    for rate = 1:length(abs_rate)
        mtr_result = []; stdtr_result = []; mt_result = []; std_result = [];
        for run = 1:tot_run
            for f = 1:tot_fold
              %% obtain training set and testing set
                test_posind = (fold_run_pos==f);
                train_posind =~ test_posind;
                test_negind = (fold_run_neg==f);
                train_negind =~ test_negind;
                
                test_pos = normal_data(test_posind,:);
                train_pos = normal_data(train_posind,:);
                test_neg = outlier_data(test_negind,:);
                train_neg = outlier_data(train_negind,:);
                
                train_data = train_pos(:,1:end-1);
                train_lbls = train_pos(:,end);
                test_data = cat(1,test_pos(:,1:end-1),train_neg(:,1:end-1),test_neg(:,1:end-1));
                test_lbls = cat(1,test_pos(:,end),train_neg(:,end),test_neg(:,end));

              %% Random filling missing values with different percentages in the training set
                temp = train_data(:,1:end-1);
                [num_data,dim] = size(temp);
                abs_num = ceil(num_data*dim*abs_rate(rate));
                abs_ind = randperm(numel(temp),abs_num);
                abs_ind = abs_ind';
                for i = 1:length(abs_ind)
                    row = fix(abs_ind(i)/dim);
                    column = rem(abs_ind(i),dim);
                    if column~=0 && row ~=0
                        temp(row,column) = nan;
                    elseif column == 0 && row ~=0
                        temp(row,dim) = nan;
                    elseif column ~=0 && row ==0
                        temp(1,column) = nan;
                    end
                end
                train_data(:,1:end-1) = temp;
                
                temp_ind = 0;
                sup_vec = [];
                optmod = [];
                v_array = [10^-2 10^-1 10^0 10^1 10^2];
                for v = 1:length(v_array)
                    count = count + 1;
                    [data_num count]
                    [model,model2] = create_model(train_data,train_lbls,v_array(v));
                    labeltr_GOCK = test_model(train_data,train_lbls,model,model2,v_array(v));
                    labels_GOCK = test_model(test_data,test_lbls,model,model2,v_array(v));
                    act_val_lbls = train_pos(:,end);
                    pred_val_lbls = labeltr_GOCK;
                    
                    temp_ind = temp_ind +1;
                    optmod{temp_ind} = model;
                    
                    [prec(temp_ind), rec(temp_ind), f11(temp_ind), accu(temp_ind)] = Evaluate(act_val_lbls,pred_val_lbls,1);
                    [prect(temp_ind), rect(temp_ind), f11t(temp_ind), accut(temp_ind)] = Evaluate(test_lbls,labels_GOCK,1);
                    
                    clear labels_GOCK labelval_GOCK labeltr_GOCK;
                end
                [max_val, opt_ind] = max(f11);
                [max_valt, opt_indt] = max(f11t); 
                %%%% Training
                trprecision(f)=prec(opt_ind); trrecall(f)=rec(opt_ind); trf1(f)=f11(opt_ind); traccuracy(f)=accu(opt_ind);
                
                %%%% Testing
                precision(f)=prect(opt_ind); recall(f)=rect(opt_ind); f1(f)=f11t(opt_ind); accuracy(f)=accut(opt_ind); 
                
                clear test_posind train_posind test_negind train_negind test_pos...
                    train_pos test_neg train_neg train_data train_lbls test_data...
                    test_lbls Ktrain Ktest labels_GOCK gm
            end
            %% results_train

            mtr_pre = mean(trprecision);
            mtr_rec = mean(trrecall);
            mtr_f1 = mean(trf1);
            mtr_acc = mean(traccuracy);
            
            result_mtr = [mtr_pre mtr_rec mtr_f1 mtr_acc];
            mtr_result = [mtr_result;result_mtr];
            
            stdtr_pre = std(trprecision);
            stdtr_rec = std(trrecall);
            stdtr_f1 = std(trf1);
            stdtr_acc = std(traccuracy);
            
            result_stdtr = [stdtr_pre stdtr_rec stdtr_f1 stdtr_acc];
            stdtr_result = [stdtr_result;result_stdtr];
            
            %% results_test
           
            mt_pre = mean(precision);
            mt_rec = mean(recall);
            mt_f1 = mean(f1);
            mt_acc = mean(accuracy);
            
            result_mt = [mt_pre mt_rec mt_f1 mt_acc];
            mt_result = [mt_result;result_mt];
            
            std_pre = std(precision);
            std_rec = std(recall);
            std_f1 = std(f1);
            std_acc = std(accuracy);
            
            result_std = [std_pre std_rec std_f1 std_acc];
            std_result = [std_result;result_std];
            
            clear result_mtr result_stdtr result_mt result_std;
        end
        res.trainmean = sum(mtr_result,1)./tot_run;
        res.trainstd = sum(stdtr_result,1)./tot_run;
        res.testmean = sum(mt_result,1)./tot_run;
        res.teststd = sum(std_result,1)./tot_run;
        
        res.performance = {'precision','recal','f1','accuracy'};
        res_all{data_num,rate} = res;
        save(sprintf('%s%d%s','res',data_num,'.mat'),'res')
        clear res;
        
    end
end
save('madm_result.mat','res_all');


