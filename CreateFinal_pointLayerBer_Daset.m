clc;clear;
tb_ber=readtable('BER_Residential_index_otherParam.csv');
Val=table2array(tb_ber(:,34:37));
Val1=sum(Val');Val2=100-Val1;
tb_ber.OtherSpace=Val2(:);
writetable(tb_ber,'BER_Complete_index.csv')