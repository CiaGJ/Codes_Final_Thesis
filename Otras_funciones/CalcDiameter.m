function [Diameter]=CalcDiameter(Initial,Final)
i=1;
Diameter(i)=Initial;
while Diameter(i) <=10
    Diameter(i+1)= Diameter(i)+1;
    i=i+1;
end
while Diameter(i) <=2*Final/3
    Diameter(i+1)=Diameter(i)+2;
    i=i+1;
end
while Diameter(i) <=Final
    Diameter(i+1)=Diameter(i)+5;
    i=i+1;
end
Diameter(i)=Final;
Diameter=Diameter';
end