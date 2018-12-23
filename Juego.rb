require_relative 'Jugadas'
require_relative 'Estrategia'
require 'io/console'

##
# Clase que representa una Partida entre dos jugadores.
class Partida

	##
	# Mapa que posee símbolos como llaves, cuyos nombres son únicos y
	# corresponden a los nombres de cada jugador, e instancias de
	# Estrategia como valores, que corresponden a la estrategia de
	# cada jugador.
	attr_reader :jugadores

	##
	# Entero que corresponde al número de rondas totales jugadas
	# en la partida
	attr_reader :total_rondas

	##
	# Mapa que posee símbolos como llaves, cuyos nombres son únicos y
	# corresponden a los nombres de cada jugador, y enteros como
	# valores, que corresponden a la puntuación acumulada de cada
	# jugador.
	attr_reader :puntaje

	##
	# Método que inicializa una Partida entre dos jugadores.
	#
	# El parámetro +play+ es un mapa que posee símbolos como 
	# llaves, cuyos nombres son únicos y corresponden a los 
	# nombres de cada jugador, e instancias de Estrategia como 
	# valores, que corresponden a la estrategia de cada jugador.
	#
	# Si +play+ es un mapa que no posee exactamente dos entradas,
	# se genera una excepción. En caso de que alguna llave de +play+
	# no sea un símbolo, se genera una excepción. Además si algún
	# valor de +play+ no es de tipo Estrategia, también se genera
	# una excepción.
	def initialize(play)
		@jugadores=Hash.new
		@total_rondas=0
		@puntaje=Hash.new
		if play.length == 2
			play.each do |nom, est| #key, value
				if !(nom.is_a? Symbol)
					raise "No se ha especificado correctamente el nombre del jugador: #{nom}."
				end
				
				if !([Manual, Uniforme, Sesgada, Copiar, Pensar].include? est.class)
					raise "#{est} no es una estrategia valida."
				end
				@jugadores[nom]=est
				@puntaje[nom]=0
			end
		else
			raise "No se especificaron la cantidad correcta de jugadores con sus estrategias."
		end
	end
	
	##
	# Método que comienza una Partida entre dos jugadores.
	#
	# El parámetro +n+ es un entero que corresponde al número
	# de rondas que deben completarse. Al final se muestra un
	# mapa que indica el puntaje obtenido por cada jugador y
	# la cantidad de rondas jugadas.
	#
	# Si +n+ no es un número positivo, se genera una excepción.
	def rondas(n)
		if n<=0
			raise "No es posible completar #{n} partidas. Indique un numero positivo."
		end
		ronditas=1
		proxs=Array.new(2)
		until ronditas>n do
			if @total_rondas == 0 #Primera ronda de la partida
				i=0
				@jugadores.each do |nom, est|
					if est.class == Copiar || est.class == Pensar
						proxs[i]=est.prox(est.primera)
					else
						proxs[i]=est.prox(Jugada.new)
					end
					puts "El jugador #{nom} ha elegido #{proxs[i]}\n"
					i+=1
				end
				
			else
				i=0
				ants=proxs #Para poder usar la jugada anterior del contrincante
				@jugadores.each do |nom, est|
					proxs[i]=est.prox(ants[(i+1)%ants.length])
					puts "El jugador #{nom} ha elegido #{proxs[i]}\n"
					i+=1
				end
			end
			#Calcula el puntaje [j1,j2]
			ptos_ronda=proxs[0].puntos(proxs[1])
			i=0
			@puntaje.each do |nom,pt|
				@puntaje[nom]=pt+ptos_ronda[i]
				i+=1
			end
			@total_rondas+=1
			puts "Se han jugado #{ronditas} ronda(s) de #{n} ronda(s) que deben completarse, en un total de #{@total_rondas} ronda(s).\n El puntaje actual es #{@puntaje}\n"
			ronditas+=1
		end
	end

	##
	# Método que comienza una Partida entre dos jugadores.
	#
	# El parámetro +n+ es un entero que corresponde al número
	# de puntos que deben alcanzarse. Al final se muestra un
	# mapa que indica el puntaje obtenido por cada jugador y
	# la cantidad de rondas jugadas.
	#
	# Si +n+ no es un número positivo, se genera una excepción.
	def alcanzar(n)
		if n<=0
			raise "No es posible alcanzar #{n} puntos. Indique un numero positivo."
		end
		proxs=Array.new(2)
		terminado=false
		while !terminado do
			if @total_rondas == 0 #Primera ronda de la partida
				i=0
				@jugadores.each do |nom, est|
					if est.class == Copiar || est.class == Pensar
						proxs[i]=est.prox(est.primera)
					else
						proxs[i]=est.prox(Jugada.new)
					end
					puts "El jugador #{nom} ha elegido #{proxs[i]}\n"
					i+=1
				end
				
			else
				i=0
				ants=proxs #Para poder usar la jugada anterior del contrincante
				@jugadores.each do |nom, est|
					proxs[i]=est.prox(ants[(i+1)%ants.length])
					puts "El jugador #{nom} ha elegido #{proxs[i]}\n"
					i+=1
				end
			end
			#Calcula el puntaje [j1,j2]
			ptos_ronda=proxs[0].puntos(proxs[1])
			i=0
			@puntaje.each do |nom,pt|
				@puntaje[nom]=pt+ptos_ronda[i]
				i+=1
				if @puntaje[nom]==n
					terminado=true
				end
			end
			@total_rondas+=1
			puts "Se han jugado un total de #{@total_rondas} ronda(s).\n El puntaje actual es #{@puntaje}\n"
		end

	end

	##
	# Método que lleva una Partida a su estado inicial,
	# es decir que el total de rondas y el puntaje de cada
	# jugador se lleva a cero.
	def reiniciar
		@total_rondas=0
		@puntaje.each do |jug,pt|
			@puntaje[jug]=0
		end
	end

end

##
# Cliente (Main)
##
##
#JUGADORES
##
jug_est=Hash.new
for i in 1..2
	## Nombre
	puts "Introduzca el nombre del jugador #{i}:"
	j1=gets.chomp
	j1=j1.gsub(/\s+/,"_").to_sym
	
	## Seleccion de estrategia
	est=""
	salir=false #Variable para salir de un loop donde se pregunte por mas de una jugada para una estrategia
	
	until ["1","2","3","4","5"].include? est do
		puts "Introduzca la estrategia del jugador #{i}:\n 1. Manual.\n 2. Uniforme.\n 3. Sesgada.\n 4. Copiar.\n 5. Pensar.\n"
		est = STDIN.getch
	end

	case est
	when "1"
		jug_est[j1]=Manual.new
	when "2" #uniforme
		jug = Array.new
		while !salir do
			uni=""
			until ["1","2","3","4","5","6"].include? uni do
				puts "Introduzca las jugadas posibles:\n 1. Piedra.\n 2. Papel.\n 3. Tijeras.\n 4. Lagarto.\n 5. Spock.\n 6. Terminar de seleccionar jugadas.\n"
				uni = STDIN.getch
			end
			case uni
			when "1" 
				jug.push(:Piedra)
			when "2" 
				jug.push(:Papel)
			when "3" 
				jug.push(:Tijera)
			when "4"
				jug.push(:Lagarto)
			when "5"
				jug.push(:Spock)
			when "6"
				salir=true
			end	
		end
		jug_est[j1]=Uniforme.new(jug)
	when "3" #sesgada
		hash_jug = Hash.new
		while !salir do
			ses=""
			until ["1","2","3","4","5","6"].include? ses do
				puts "Introduzca las jugadas posibles:\n 1. Piedra.\n 2. Papel.\n 3. Tijeras.\n 4. Lagarto.\n 5. Spock.\n 6. Terminar de seleccionar jugadas.\n"
				ses = STDIN.getch
			end
			prob = nil
			puts "Introduzca la probabilidad: "
			until prob.is_a? Integer do
				prob = Integer(gets.chomp) rescue nil
			end
			case ses
			when "1" 	
				hash_jug[:Piedra]=prob
			when "2" 
				hash_jug[:Papel]=prob
			when "3" 
				hash_jug[:Tijera]=prob
			when "4"
				hash_jug[:Lagarto]=prob
			when "5"
				hash_jug[:Spock]=prob
			when "6"
				salir=true
			end	
		end
		jug_est[j1]=Sesgada.new(hash_jug)
	when "4" #copiar
		cop=""
		until ["1","2","3","4","5"].include? cop do
			puts "Introduzca la primera jugada:\n 1. Piedra.\n 2. Papel.\n 3. Tijeras.\n 4. Lagarto.\n 5. Spock.\n"
			cop = STDIN.getch
		end
		case cop
		when "1"
			jug_est[j1]=Copiar.new(Piedra.new)
		when "2" 
			jug_est[j1]=Copiar.new(Papel.new)
		when "3" 
			jug_est[j1]=Copiar.new(Tijera.new)
		when "4"
			jug_est[j1]=Copiar.new(Lagarto.new)
		when "5"
			jug_est[j1]=Copiar.new(Spock.new)
		end	
	
	when "5"
		jug_est[j1]=Pensar.new
	end
end

##
# JUEGO
##
partida=Partida.new(jug_est)
jugar=true
while jugar do
	input=""
	until ["1","2","3","4"].include? input do
		puts "Introduzca el numero correspondiente a alguna de las siguientes opciones:\n 1. Jugar por rondas.\n 2. Jugar por numero de puntos.\n 3. Reiniciar partida.\n 4. Salir.\n"
		input = STDIN.getch
	end
	n = nil
	case input
	when "1" #rondas
		puts "Introduzca la cantidad de rondas a jugar: "
		until n.is_a? Integer do
			n = Integer(gets.chomp) rescue nil
		end
		partida.rondas(n)
	when "2" #alcanzar
		puts "Introduzca la cantidad de puntos que se deben alcanzar: "
		until n.is_a? Integer do
			n = Integer(gets.chomp) rescue nil
		end
		partida.alcanzar(n)
	when "3" #reiniciar
		partida.reiniciar
		puts"La partida se ha reiniciado.\n"
	when "4"
		jugar=false
		puts "¡Adios!"
	end

end
par = Partida.new({:Yo => Manual.new, :AlterEgo => Manual.new})
puts "INICIALMENTE en la partida #{par.jugadores}\npuntaje #{par.puntaje} en #{par.total_rondas} rondas"
puts "CON RONDAS"
par.rondas(2)
par.reiniciar
puts "Luego de REINICIAR, en la partida #{par.jugadores}\npuntaje #{par.puntaje} en #{par.total_rondas} rondas"