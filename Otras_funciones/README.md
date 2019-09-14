# CalcNA
    [NA,ncore,ncladding]=CalcNA(LambdaUpper,LambdaLower)
Esta función calcula la apertura numérica de la fibra óptica con los índices de Sellmeier.

# CalcDob
    [Dob]=CalcDob(Initial,Step,Final)
Con esta función podemos obtener un vector a partir de introducir el primer (**Initial**) y último (**Final**) valor del vector, así como el espaciamiento entre los valores que conforman el vector (**Step**). En las simulaciones que yo he realizado lo he utilizado para calcular un vector con distintos diámetros que definen el objetivo a medir. 

# CalcDistLog
    [Distance]=CalcDistLog
Esta función calcula un vector desde 0.01 hasta 10 de forma logarítmica. En las simulaciones que he realizado lo he utilizado para calcular un vector con dichos valores para la distancia dada entre el pirómetro y la supeficie a medir.

# CalcDiameter
    [Diameter]=CalcDiameter(Initial,Final)
Con esta función podemos obtener un vector a partir de introducir el primer (**Initial**) y último (**Final**) valor del vector con un espaciamiento un poco característico entre los valores que conforman el array. En las simulaciones que he realizado lo he utilizado para calcular un vector con distintos diámetros del núcleo de la fibra.