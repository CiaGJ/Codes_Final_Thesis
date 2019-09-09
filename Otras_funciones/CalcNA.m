function [NA,ncore,ncladding]=CalcNA(LambdaUpper,LambdaLower)
load('Data/SellmeierCoefSilicaFiber.mat');
LambdaEval=(LambdaUpper+LambdaLower)/(2);
LambdaEval=(LambdaEval*1e+6)^2;
ncore=double(sqrt(1+(LambdaEval)*((A11)/(LambdaEval-L11^2))+((A12)/(LambdaEval-L12^2))+((A13)/(LambdaEval-L13^2))));
ncladding=double(sqrt(1+(LambdaEval)*((A21)/(LambdaEval-L21^2))+((A22)/(LambdaEval-L22^2))+((A23)/(LambdaEval-L23^2))));
NA=sqrt(ncore^2-ncladding^2);
end