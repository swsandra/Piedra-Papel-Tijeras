Aurivan Castro  14-10205
Sandra Vera     14-11130

Proyecto #3: Laboratorio de Lenguajes de Programación
Piedra, Papel, Tijera, Lagarto, Spock

    Para generar la documentación se corre en la terminal el comando:
        rdoc Jugadas.rb Estrategia.rb Juego.rb

    Se asume que el parametro j de las funciones prox de las subclases de
Estrategia corresponde a la jugada de la ronda anterior del contrincante.
En el caso de la subclase Pensar, la primera jugada siempre es Piedra por
la manera en la que se toman las decisiones de esta estrategia que se 
definió en el enunciado del proyecto.
    En la clase Partida en el método rondas, cuando se están empezando las
rondas, si la estrategia es Copiar o Pensar, se pasa como argumento a prox 
en j la jugada que está guardada en el atributo de instancia primera, pues
ahí está definida la primera jugada a realizar.
    Además, por la manera en la que se guardan las jugadas anteriores en 
Partida, se pasan a las estrategias para que calculen su proxima jugada una
vez se haya realizado otro movimiento, por lo que para la estrategia Pensar
no se registra la última jugada al llamar al método rondas o alcanzar. Sin
embargo, si por ejemplo se llaman en orden a los métodos rondas y alcanzar,
se registra la última jugada de rondas, más no la de alcanzar.