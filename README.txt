Aurivan Castro  14-10205
Sandra Vera     14-11130

Proyecto #3: Laboratorio de Lenguajes de Programación
Piedra, Papel, Tijera, Lagarto, Spock

    Se asume que el parametro j de las funciones prox de las subclases de
Estrategia corresponde a la jugada de la ronda anterior del contrincante.
En el caso de la subclase Pensar, la primera jugada siempre es Piedra por
la manera en la que se toman las decisiones de esta estrategia que se 
definió en el enunciado del proyecto.
    En la clase Partida en el método rondas, cuando se están empezando las
rondas, si la estrategia es Copiar o Pensar, se pasa como argumento a prox 
en j la jugada que está guardada en el atributo de instancia primera, pues
ahí está definida la primera jugada a realizar.