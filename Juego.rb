require_relative 'Jugadas'
require_relative 'Estrategia'
require 'io/console'

class Partida

	#jugadores es un hash key simbolo y value de clase estrategia
	attr_reader :jugadores, :total_rondas, :puntaje

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
	
	def rondas(n)
		if n<=0
			raise "No es posible completar #{n} partidas."
		end
		ronditas=0
		proxs=Array.new(2)
		until ronditas>=n do
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
			puts "Al final de la rondita #{ronditas} (total: #{@total_rondas}) el puntaje es #{@puntaje}"
			ronditas+=1
			@total_rondas+=1
		end
	end

	def alcanzar(n)
		if n<=0
			raise "No es posible alcanzar #{n} puntos."
		end

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
			puts "El puntaje es #{@puntaje} (total: #{@total_rondas})."
			@total_rondas+=1
		end

	end

	def reiniciar
		@rondas=0
		@puntaje.each do |jug|
			@puntaje[jug]=0
		end
	end

end

#par = Partida.new({:Yo => Manual.new, :AlterEgo => Sesgada.new({:Piedra => 2, :Papel=>5, :Papel=>3})})
par = Partida.new({:Yo => Manual.new, :AlterEgo => Manual.new})
puts "Inicialmente en la partida #{par.jugadores}\npuntaje #{par.puntaje} en #{par.total_rondas} rondas"
par.rondas(2)