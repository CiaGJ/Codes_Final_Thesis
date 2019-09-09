function [SolidAngleArea]=FunctionSpotDiameter(Dob,SpotDiameter,Distance,AceptanceAngle,Diameter)

 syms r u Theta x y

if Dob<=SpotDiameter %No muy depurado
    
    R1=Distance*tan(AceptanceAngle); %Radio de la apertura numérica
    R2=Diameter/2; % Radio del núcleo de la fibra.
    
    x=((r).^2-(R2).^2+(R1).^2)/(2*r); % Formula del coseno (faltaría multiplicar el denominador por u)
    y=abs(sqrt((4*r.^2*R1.^2-(r^2-R2^2+R1.^2)^2)/(4*r.^2))) ;
    ThetaLimitMean=atan(y/x);
    ThetaLimitMean=simplify(ThetaLimitMean);

    G0=int(1,'Theta',-ThetaLimitMean,+ThetaLimitMean);
    G0=simplify(G0);

    UUpper=R1;
    ULower=r-R2;
    G1=int((Distance.^2*u)/((Distance.^2+u.^2)^2),'u',ULower,UUpper);
    G1=simplify(G1);

    G2=8*G1*G0;
    G2=simplify(G2);

    G3=2*pi;

    G4=r*G2;
    Gr=simplify(G4);
    Rob=Dob/2;
    SolidAngleArea=double(int(Gr,'r',0,Rob)); 
    
    %fprintf('Solid Angle & Area Mean for ROb <= RNAMean:   %d      [m^2*Sr]\n\n',SolidAngleAreaMean);

else
    SolidAngleArea=((pi^2*(Diameter.^2))/(8))*(1-cos(2*AceptanceAngle));
end
end