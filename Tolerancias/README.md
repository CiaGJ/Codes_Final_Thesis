# ErrorPower.m
    [DR_core,DDistance,DNA,DP]=ErrorPower(Erf,Et,ENA,Mean,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Temperature,Emissivity,Dob)

## Parámetros de entrada
Los párametros de entrada de esta función son los siguientes:
 - *Mean*: cuyos valores pueden ser 'On', 'Off'
    
> NOTE: This value represents a digital switch to choose between an approximated or exactcalculation of all integral expressions. The more accurate method uses the the symbolic toolbox of Matlab.
        
>Important Note: symbolic method (mean = off) takes more time than
 the approximated method and I could appreciate no significant difference between their errors.

 - *Losses*: cuyos valores pueden ser 'On', 'Off'
> NOTE:
 This value represent a logic switch to select if you want to take into account
 the insertion losses of all opto-electronics devices which take
 part in the experimental setup.

 - *PdMaterial*: 'InGaAs', 'InGaAsEx', 'Ge', 'Si', 'PbS', 'PbSe'
     
>NOTE:
 This parameter represents the material of your photodetector. This simulation can
 be run using different photodetectors although we always use InGaAs photodetectors.
 I codded this improvement because one upon a time we were studding the performance
 of the fiber-optic pyrometer using different photodetector responsivities.

 - *LambdaUpper*: 1700 (1550nm Channel) or 1379um (1310nm Channel)
 - *LambdaLower*: 1430 (1550nm Channel) or 0800um (1310nm Channel)
 > NOTE:
 These parameters represent the upper and lower wavelength limits of the
 wavelength band that you want to simulate, in microns. You must run
 this simulation programn as many times as number of channels you
 have. If you have two channels, as it's our case (1310 and 1550nm), you'll run the program two times.
 
 >Please, pay attention to the upper wavelength value of the 1550nm channel (1700nm) and the lower wavelength value of the 1310nm
 channel (800nm). Are these value familiar to you? These values
 corresponds to the upper and lower limits of a InGaAs
 photodetector. Why? It's easy, our fiber-optic filter works
 as a high-pass or low-pass filter, this behaviour depends on the filter output you choose.
 So, the wavelength range of the fiber-optic pyrometer is strongly limited by the
 wavelength limits of the photodetector responsivity, see the
 Characterization Responsivities sheet of my Excel document (Summary.xlsx)

 - *Diameter*: 62.5 +/-3 um (recommended tolerance)
> NOTE:
 This parameter represents the diameter of the optical fiber used to
 gather the radiation in microns. The tolerance represents the minimum and
 maximum fiber diameter. Practically, you ought to measure the fiber
 diameter and then you insert that value here. 

- *Distance*:  0.3 +/-0.075 mm (recommended tolerance)
 > NOTE:
 This value represents the distance between the fiber end and the
 hot surface in millimetres. You can also include the tolerance of
 your measurement.

 - *DistanceConnector*: 4 - 9.3 mm
 > NOTE:
 This value represents the distance between the fiber end and the
 photodetector surface in millimetres. This value is normally fixed by the
 mechanical structure of your photodetector. I recommend you to read
 your photodetector datasheet for more information.

 - *Length*: 0.5 m
 > NOTE:
 This value represents the length of the optical fiber in metres.

 - *Temperature*: 650ºC
 > NOTE:
 This value represents the temperature of the hot surface in Celsius
 degrees

 - *Emissivity*: 1 (NOTE: Blackbody emissivity is equal at 1)
 > NOTE:
 This value represents the emissivity of the hot surface measured by
 the optical fiber. This value is a dimensionless unit.

- *Dob*: diámetro de la superficie a medir. Introducir en micrometros.

- *Erf*: error asociado al radio del núcleo de la fibra. Introducir en micrometros.

- *Et*: error asociado a la distancia a la que se posiciona el pirómetro respecto a la superficie que se quiere medir. Introducir en milimetros.

- *ENA*: error asociado a la apertura numérica de la fibra. 

## Funciones integradas en PirometerDob.m
A continuación, voy a explicar brevemente las funciones que se encuentran integradas en Pirometer7.m:

### FunctionAcceptanceAngle

    [NA,SolidAngleArea,SpotDiameter,AceptanceAngle]=FunctionAcceptanceAngle(Mean,LambdaUpper,LambdaLower,Diameter,Distance,Dob)

Esta función calcula el ángulo sólido (**SolidAngleArea**), el ángulo de aceptancia (**AcceptanceAngle**) y el diámetro del cono de aceptancia (**SpotDiameter**). La función calcula los índices de refracción del núcleo y la cubierta de la fibra a partir de los índices de Sellmeier, con estos calcula la apertura numérica (**NA**) de la fibra y con este dato el ángulo de aceptancia. A partir de estos se calculará el diámetro del cono de aceptancia. Después con la función “FunctionSpotDiameter” calculará el ángulo sólido.
Existe una diferencia en los cálculos dependiendo si estos se están realizando con los valores medios del rango espectral o con los valores exactos del mismo. Actualmente, y tal y como está planteada la función “FunctionSpotDiameter”, el correcto funcionamiento de esta función solo es posible para los valores medios del rango espectral y no para los valores exactos.

Los índices de Sellmeier utilizados se encuentran en la carpeta _Data_.

### FunctionSpotDiameter
	[SolidAngleArea]=FunctionSpotDiameter(Dob,SpotDiameter,Distance,AceptanceAngle,Diameter)

Esta función se encuentra integrada en la función _“FunctionAcceptanceAngle”_. Se utiliza para calcular el ángulo sólido dependiendo de si el diámetro del objeto a medir es menor que el diámetro del cono de aceptancia. Esta función recurre a las funciones _"casoI"_, _"casoII"_ y _"casoIII"_.

### casoI
    [T1,T2,T3,T4]=casoI(t,rf,rob,rmax)

Esta función se utiliza cuando el caso que estamos analizando se corresponde con el primer caso de estudio declarado en mi TFG. Además, recurre a las funciones _"fa"_, _"fbI"_ y _"fcI"_ y cuyos encabezados son los siguientes:
    [T1]=fa(t,rmax,Limit)
    [T2,T3]=fbI(rf,t,rmax,Limit)
    [T4]=fcI(t,rf,rmax,Limit)    

### casoII
    [T1,T2,T3,T4,T5]=casoII(t,rf,rob,rmax)

Esta función se utiliza cuando el caso que estamos analizando se corresponde con el segundo caso de estudio declarado en mi TFG. Además, recurre a las funciones _"faII"_, _"fbII"_ y _"fcII"_ y cuyos encabezados son los siguientes:
    [T1,T2]=faII(rf,t,Limit)
    [T3,T4]=fbII(rf,t,rmax,Limit)
    [T5]=fcII(t,rf,rmax,Limit)  
    
### casoIII
    [T1,T2,T3,T4]=casoIII(t,NA,rf,rob,ran)

Esta función se utiliza cuando el caso que estamos analizando se corresponde con el tercer caso de estudio declarado en mi TFG. Además, recurre a las funciones _"f3"_, _"f2"_ y _"f1"_ y cuyos encabezados son los siguientes:
    [T1,T2]=f3(rf,t,Limit)
    [T3]=f2(t,rf,Limit)
    [T4]=f1(rf,t,NA,Limit)
    
### FunctionResponsivity

    [Responsivity,CouplingEfficience]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector,AceptanceAngle)

Esta función calcula la responsividad del fotodetector y la eficacia del acople entre este y la fibra por la que se trasmite la radiación recogida. Se recurre a la función _“FunctionCouplingEfficience”_ en el caso de que se esté trabajando con fotodetectores de PbSe y PbS. Para el resto de casos el output **CouplingEfficience** recibe el valor de la unidad. En caso de que se introduzca un material de los cuales no se tengan datos, el programa dará un mensaje de error.

Los datos de los materiales del fotodetector utilizados se encuentran en la carpeta _Data_.

### FunctionCouplingEfficience

    [CouplingEfficience]=FunctionCouplingEfficience(AceptanceAngle,Diameter,DistanceConnector)

Esta función solo se utiliza cuando se está trabajando con fotodetectores de PbSe y PbS. Se encuentra integrada en la función _“FunctionResponsivity"_. Calcula la eficacia del acople entre la fibra y el fotodetector. Recurre a función _“FunctionEfficiencyConectorization”_ para realizar los cálculos.

### FunctionEffiencyConectorization

    [PhotodiodeFffectiveArea,R2]=FunctionEfficiencyConectorization(Width,Height,Separation,AceptanceAngleMean,Diameter,DistanceConnector)

Esta función calcula el área efectiva de los fotodetectores de PbSe y PbS. Se encuentra integrada en la función _“FunctionCouplingEfficience”_.


### FunctionPlanckNoSolidAngle
    [Signal,Power]=FunctionPlanckNoSolidAngle(Responsivity,Emissivity,Temperature,LambdaLower,LambdaUpper,PdMaterial)

Esta función calcula la potencia de salida de los fotodetectores y la corriente eléctrica que circula por los mismos sin tener en cuenta el ángulo sólido. Utiliza la aproximación de Wein de la ecuación de Planck. 

### d_dr_core
    [D1]=d_dr_core(Diameter,Distance,NA)
Esta función calcula la derivada parcial del ángulo sólido para el segundo caso de estudio con respecto al radio del núcleo de la fibra.

### d_dDistance
    [D2]=d_dDistance(Diameter,Distance,NA)
Esta función calcula la derivada parcial del ángulo sólido para el segundo caso de estudio con respecto a la distancia a la que se posiciona el pirómetro respecto a la superficie que se quiere medir.

### d_dNA
    [D3]=d_dNA(Diameter,Distance,NA)
Esta función calcula la derivada parcial del ángulo sólido para el segundo caso de estudio con respecto a la apertura numérica de la fibra óptica.


## Ejemplos de utilización

Se pueden encontrar archivos .mat con los que pueden realizar las simulaciones. Por ejemplo, si se quiere acceder a los datos del canal de 1310 nm deberá escribir en la _Command Window_ lo siguiente:

    load('Data_Test/DataError.mat');

Y, a continuación, puede ejecutar la función Error Power con el encabezado indicado al principio del documento.