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
		until ronditas>n do
			if @total_rondas == 0 #Primera ronda de la partida
				i=0
				@jugadores.each do |nom, est|
					if @jugadores[nom].class == Copiar || @jugadores[nom].class == Pensar
						proxs[i]=@jugadores[nom].prox(@jugadores[nom].primera)
					else
						proxs[i]=@jugadores[nom].prox(Jugada.new)
					end
					i+=1
				end
				
			else
				i=0
				ants=proxs #Para poder usar la jugada anterior del contrincante
				@jugadores.each do |nom|
					proxs[i]=@jugadores[nom].prox(ants[(i+1)%ants.length])
					i+=1
				end
			end
			#Calcula el puntaje [j1,j2]
			ptos_ronda=proxs[0].puntos(proxs[1])
			i=0
			@puntaje.each do |nom|
				@puntaje[nom]+=ptos_ronda[i]
				i+=1
			end
			puts "Al final de la rondita #{rondita} (total: #{@total_rondas}) el puntaje es #{@puntaje}"
			ronditas+=1
			@total_rondas+=1
		end
	end

	def alcanzar(n)
		if n<=0
			raise "No es posible alcanzar #{n} puntos."
		end
	end

	def reiniciar
		@rondas=0
		@puntaje.each do |jug|
			@puntaje[jug]=0
		end
	end

end

par = Partida.new({:Yo => Manual.new, :AlterEgo => Sesgada.new({:Piedra => 2, :Papel=>5, :Papel=>3})})
puts "Inicialmente en la partida #{par.jugadores}\npuntaje #{par.puntaje} en #{par.total_rondas} rondas"