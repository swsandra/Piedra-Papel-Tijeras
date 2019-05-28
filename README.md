# Proyecto #3: Laboratorio de Lenguajes de Programación I
## Piedra, Papel, Tijeras, Lagarto, Spock

Modelado del juego Piedra, Papel, Tijeras, Lagarto, Spock, que permite realizar partidas entre dos jugadores, un jugador y la máquina o dos máquinas. Las jugadas de la máquina se determinan mediante probabilidades o estrategias definidas en el enunciado del proyecto como:
* Distribución uniforme.
* Sesgada basada en probabilidades de cada jugada.
* Copiar jugada anterior.
* Pensar (explicada con detalle en el [enunciado](https://github.com/swsandra/Piedra-Papel-Tijeras/blob/master/Enunciado.pdf))

Asimismo permite mostrar estadísticas de las partidas.

Autores:

* Aurivan Castro (14-10205@usb.ve)
* Sandra Vera (14-11130@usb.ve)

## Sobre la Implementación

En cuanto a las subclases de la clase base `Estrategia`, se asume que el parametro `j` de las funciones `prox` corresponde a la jugada de la ronda anterior del contrincante.

En el caso de la subclase `Pensar`, la primera jugada siempre es Piedra por la manera en la que se toman las decisiones para aplicar esta estrategia (definida en el [enunciado](https://github.com/swsandra/Piedra-Papel-Tijeras/blob/master/Enunciado.pdf) del proyecto).

En método `rondas` de la clase `Partida`, cuando se están empezando las rondas, si la estrategia es `Copiar` o `Pensar`, se pasa como argumento a `prox` en `j` la jugada que está guardada en el atributo de instancia `primera`, pues ahí está definida la primera jugada a realizar. Además, por la manera en la que se guardan las jugadas anteriores en `Partida`, éstas son pasadas a las estrategias para que calculen su proxima jugada una
vez su contrincante haya realizado otro movimiento, por lo que para la estrategia `Pensar` no se registra la última jugada al llamar los métodos `rondas` o `alcanzar`. Sin embargo, si por ejemplo se llaman en orden a los métodos `rondas` y `alcanzar`, se registra la última jugada de `rondas`, más no la de `alcanzar`.

## Documentación

Para generar la documentación se corre en la terminal el comando:
    ```rdoc Jugadas.rb Estrategia.rb Juego.rb```