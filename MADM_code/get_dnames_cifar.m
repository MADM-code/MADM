clearvars -except a b res_all data_num path res_acc res_gmean

if data_num == 1
    dname = 'CIFAR10_0';
    dnames = [path dname];
end
if data_num == 2
    dname = 'CIFAR10_1';
    dnames = [path dname];
end
if data_num == 3
    dname = 'CIFAR10_2';
    dnames = [path dname];
end
if data_num == 4
    dname = 'CIFAR10_3';
    dnames = [path dname];
end
if data_num == 5
    dname = 'CIFAR10_4';
    dnames = [path dname];
end
if data_num == 6
    dname = 'CIFAR10_5';
    dnames = [path dname];
end
if data_num == 7
    dname = 'CIFAR10_6';
    dnames = [path dname];
end
if data_num == 8
    dname = CIFAR10_7';
    dnames = [path dname];
end
if data_num == 9
    dname = 'CIFAR10_8';
    dnames = [path dname];
end
if data_num == 10
    dname = 'CIFAR10_9';
    dnames = [path dname];
end
if data_num == 11
    dname = 'MVTec-AD_screw';
    dnames = [path dname];
end
if data_num == 12
    dname = 'MVTec-AD_bottle';
    dnames = [path dname];
end
if data_num == 13
    dname = 'MVTec-AD_pill';
    dnames = [path dname];
end
if data_num == 14
    dname = 'MVTec-AD_cable';
    dnames = [path dname];
end
if data_num == 15
    dname = 'MVTec-AD_hazelnut';
    dnames = [path dname];
end
% if data_num == 16
%     dname = 'shuttle';
%     dnames = [path dname];
% end