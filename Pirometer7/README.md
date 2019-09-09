# Pirometer7.m
    [Signal,PowerW,PowerdBm]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,Temperature,Emissivity)

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

## Funciones integradas en Pirometer7.m
A continuación, voy a explicar brevemente las funciones que se encuentran integradas en Pirometer7.m:

### FunctionAcceptanceAngle

    [SolidAngleArea,AceptanceAngle,SpotDiameter]=FunctionAcceptanceAngle(Mean,LambdaLower,LambdaUpper,Lambda,Diameter,Distance)

Esta función calcula el ángulo sólido (**SolidAngleArea**), el ángulo de aceptancia (**AcceptanceAngle**) y el diámetro del cono de aceptancia (**SpotDiameter**). La función calcula los índices de refracción del núcleo y la cubierta de la fibra a partir de los índices de Sellmeier, con estos calcula la apertura numérica de la fibra y con este dato el ángulo de aceptancia. A partir de estos se calculará el diámetro del cono de aceptancia y el ángulo solido.

Los índices de Sellmeier utilizados se eencuentran en la carpeta _Data_.

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

### FunctionLosses

    [SystemLosses,SystemLossesdB]=FunctionLosses(Losses,PdMaterial,LambdaUpper,LambdaLower,Length)

Esta función calcula el valor de las perdidas que se dan en el pirómetro teniendo en cuenta tres aspectos: las pérdidas en los conectores FC/PC, las pérdidas por atenuación en la fibra y las pérdidas en el filtro WDM. El parámetro **Losses** determinará si los factores de perdidas de los aspectos anteriormente mencionados se tienen en cuenta o no.

### FunctionPlanck

    [Signal,Power]=FunctionPlanck(Responsivity,Emissivity,Temperature,SolidAngleArea,LambdaLower,LambdaUpper,PdMaterial)

Esta función calcula la potencia de salida de los fotodetectores y la corriente eléctrica que circula por los mismos. Utiliza la aproximación de Wein de la ecuación de Planck.

### FunctionPlanckLosses

    [Signal,PowerW,PowerdBm]=FunctionPlanckLosses(Power,Signal,SystemLosses,CouplingEfficience,PdMaterial,Mean)

Esta función calcula los valores de la potencia de salida de los fotodetectores y la corriente eléctrica que circula por los mismos teniendo en cuenta las pérdidas del sistema y la eficacia del acople entre la fibra y los fotodetectores.

## Ejemplos de utilización

- Para el canal de 1550nm:
    
        Mean: 'Off'; 
        Losses: 'On';
        PdMaterial: 'InGaAs';
        LambdaUpper = 1700;
        LambdaLower = 1379;
        Diameter = 62.5;
        Distance = 0.3;
        DistanceConnector = 4;
        Length = 0.5;
        Temperature = 650;
        Emissivity = 1;
        
        FUNCTION STRUCTURE:
        [Signal,PowerW,PowerdBm]=Pirometer7('Off','On','InGaAs',1700,1430,62.5,0.3,4,0.5,650,1)

- Para el canal de 1310nm:

        Mean: 'Off'; 
        Losses: 'On';
        PdMaterial: 'InGaAs';
        LambdaUpper = 1430;
        LambdaLower = 800;
        Diameter = 62.5;
        Distance = 0.3;
        DistanceConnector = 4;
        Length = 0.5;
        Temperature = 650;
        Emissivity = 1;

        FUNCTION STRUCTURE:
        [Signal,PowerW,PowerdBm]=Pirometer5('Off','On','InGaAs',1430,800,62.5,0.3,4,0.5,650,1)


Además, pueden encontrar archivos .mat con los que pueden realizar las simulaciones. Por ejemplo, si se quiere acceder a los datos del canal de 1310 nm deberá escribir en la _Command Window_ lo siguiente:

    load('Data_Test/Data1310.mat');

Y, a continuación, puede ejecutar la función Pirometer7 con el encabezado indicado al principio del documento.

## Simulaciones realizadas
Para la realización del trabajo de fin de grado se desarrollaron alguna funciones también incluidas en esta carpeta. Estas funciones son:

### IterationTempDiamenter
    [T]=IterationTempDiamenter(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity)

Esta función calcula la potencia óptica medida por el fotodetector para un rango de temperaturas. El inicio y final de dicho rango se introducen en **InitialTemperature** y **FinalTemperature**, respectivamente, y el espaciamiento entre los valores en **StepTemperature**. Nos devuelve un tabla en la que en la primera columna se guardan los valores de temperatura y en la segunda los valores de la potencia óptica cálculada para la temperatura correspondiente.

### IterationTempDiamenterNoise
    [T]=IterationTempDiamenterNoise(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity,Noise)

Esta función opera de forma similar a _"IterationTempDiamenter"_ pero tiene en cuenta el _offset de ruido_ (**Noise**) del fotodetector indicado por el fabricante.

### IterationTempDiamenterNoise1
    [TemperatureVector,ResultPowerW]=IterationTempDiamenterNoise1(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity,Mode,Limit)

Esta función opera de forma similar a _"IterationTempDiamenterNoise"_ pero tiene en cuenta el limite (**Limit**) impuesto por la tarjeta de adquisición, así como, el modo en el que esta operando el fotodetector (si es _"Low Gain"_ o _"High Gain"_). Para ello, esta función recurre a _"DataMode"_.

### DataMode
    [R,Noise]=DataMode(Mode)

A partir de introducir el modo en el que opera el fotodetector ('HG' o 'LG') obtenemos la relación W/V y el _offset de ruido_ al que está sometido el sistema para el modo escogido.
