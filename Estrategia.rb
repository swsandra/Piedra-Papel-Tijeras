require_relative 'Jugadas'
require 'io/console'

class Estrategia

	# Esta funcion se debe especializar
	#luego para mostrar los parametros
	#de confg de cada estrategia
	def to_s
		"#{self.class.name}"
	end
	
	# No estoy clara si prox y reset
	#se definen aqui igual

end

class Manual < Estrategia
	def prox(j)
		if j.is_a? Jugada
			input = ""
			until ["1","2","3","4","5"].include? input do
				puts "Introduzca el numero correspondiente a alguna de las siguientes opciones:\n 1. Piedra\n 2. Papel\n 3. Tijera\n 4. Lagarto\n 5. Spock\n"
				input = STDIN.getch
			end
			case input
			when "1"
				puts "Ha seleccionado Piedra."
				return Piedra.new
			when "2"
				puts "Ha seleccionado Papel."
				return Papel.new
			when "3"
				puts "Ha seleccionado Tijera."
				return Tijera.new
			when "4"
				puts "Ha seleccionado Lagarto."
				return Lagarto.new
			when "5"
				puts "Ha seleccionado Spock."
				return Spock.new
			end
		else
			raise "Jugada suministrada invalida"
		end
	
	end

end

class Uniforme < Estrategia

	attr_reader :jugadas

	#Esta distr, la prob es de 1/n para c/movimiento
	def initialize(moves)
		if moves.length > 0
			moves.each do |mov|
				if !(mov.is_a? Jugada) 
					raise "Alguna jugada de la lista no es valida"
				end
			end
		else
			raise "No existen jugadas en la lista"
		end
		@jugadas = moves.uniq{|mov| [mov.class]}
	end

	def prox(j)
		if j.is_a? Jugada
			return @jugadas[rand(@jugadas.length)]
		else
			raise "Jugada suministrada invalida"
		end
	end

end

#ESTE LINK PUEDE SER PARA SESGADA
#https://softwareengineering.stackexchange.com/questions/150616/get-weighted-random-item


=begin
manual = Manual.new
manual.prox(Jugada.new)
=end
uni = Uniforme.new([Piedra.new, Piedra.new, Papel.new, Tijera.new, Tijera.new])
#uni1 = Uniforme.new([]) da error
puts "#{uni.jugadas}"
puts "#{uni.prox(Jugada.new)}"
