clear;
clc;
load('eurusd10k');
data=eurusd10k;
[num_rows num_cols]= size(data);
for i = 1 : num_cols 
    for j=2 : num_rows
        if isnan(data(j,i))
            data(j,i)=data(j-1,i);
        end
    end
end
clear i j num_cols num_rows;

out='eurusd10k_c';
save(out,'data');
clear all;