function [Dob]=CalcDob(Initial,Step,Final)
n=((Final-Initial)/Step);
Dob=zeros(n,1);
for i=1:1:n
   Dob(i)=Initial+i*Step; 
end
end