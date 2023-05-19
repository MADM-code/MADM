function [model,model2] = create_model(train_data,train_labels,v)
parameters = madm_parameter();
parameters.v = v;
[model, model2] = madm_train(train_data,train_labels,parameters);
end

