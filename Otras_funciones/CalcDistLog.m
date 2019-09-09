function [Distance]=CalcDistLog
k=1;
for j=0:1:2
    for i=1:1:9
        Distance(k)=i*10^(-2+j);
        k=k+1;
    end
end
Distance=Distance';

% Distance=0.09+.001:.005:0.09+0.2;
end