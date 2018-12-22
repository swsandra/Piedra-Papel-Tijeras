require_relative 'Jugadas'
require 'io/console'

class Estrategia

	@@r = Random.new(42) #With this seed it generates the same numbers for Sesgada.prox
	#@@r = Random.new

	def to_s
		"#{self.class.name}"
	end

	def sym_to_class(sym)
		if sym==:Piedra
			return Piedra.new
		elsif sym==:Papel
			return Papel.new
		elsif sym==:Tijera
			return Tijera.new
		elsif sym==:Lagarto
			return Lagarto.new
		elsif sym==:Spock
			return Spock.new
		end
	end

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
			raise "#{j} no es una jugada valida."
		end
	
	end

end

class Uniforme < Estrategia

	attr_reader :jugadas

	#Esta distr, la prob es de 1/n para c/movimiento
	def initialize(moves)
		if moves.length > 0
			moves.each do |mov|
				if !(mov.is_a? Symbol) || !([:Piedra, :Papel, :Tijera, :Lagarto, :Spock].include? mov)
					raise "#{mov} no es una jugada valida."
				end
			end
		else
			raise "No existen jugadas en la lista."
		end
		@jugadas = moves.uniq#{|mov| [mov.class]} #esto es cuando son instancias
	end

	def prox(j)
		if j.is_a? Jugada
			return sym_to_class(@jugadas[@@r.rand(@jugadas.length)])
		else
			raise "#{j} no es una jugada valida."
		end
	end

	def to_s
		str="#{self.class.name} con configuracion:\n Jugadas posibles:"
		@jugadas.each do |j|
			str.concat" #{j},"
		end
		return str[0...str.length-1].concat "."
	end

end

class Sesgada < Estrategia

	attr_reader :jugadas, :intervals, :sum

	def initialize(moves)
		@intervals=Hash.new
		if moves.length > 0
			moves.each do |mov, prob| #key, value
				if !(mov.is_a? Symbol) || !([:Piedra, :Papel, :Tijera, :Lagarto, :Spock].include? mov)
					raise "#{mov} no es una jugada valida."
				end
			end
		else
			raise "No existen jugadas en el mapa."
		end
		@jugadas = moves #No hace falta hacer uniq, el hash automaticamente toma el ultimo valor
		@sum=0
		@jugadas.each do |jug, prob|
			@sum+=prob
			@intervals[jug] = @sum
		end

	end
	
	#Using this approach (second solution) https://softwareengineering.stackexchange.com/questions/150616/get-weighted-random-item
	def prox(j)
		if j.is_a? Jugada
			n=@@r.rand(@sum)
			puts "n was #{n}"
			@intervals.each do |jug,prob|
				if prob>n
					return sym_to_class(jug)
				end
			end
		else
			raise "#{j} no es una jugada valida."
		end
	end

	def to_s
		str="#{self.class.name} con configuracion:\n Jugadas posibles:\n"
		@jugadas.each do |j, p|
			str.concat"\t#{j} con probabilidad #{p/(@sum*1.0)}.\n"
		end
		return str
	end

end

class Copiar < Estrategia

	attr_reader :primera

	@primera

	def initialize(j)
		if j.is_a? Jugada
			@primera=j
		else
			raise "#{j} no es una jugada valida."
		end
	end

	def prox(j)
		if j.is_a? Jugada
			return j
		else
			raise "#{j} no es una jugada valida."
		end
	end

	def to_s
		"#{self.class.name} con configuracion:\n Jugada inicial: #{@primera}\n"

	end

end

class Pensar < Estrategia

	attr_reader :piedras, :papeles, :tijeras, :lagartos, :spocks, :primera

	def initialize
		#Jugadas del oponente con # de veces jugadas
		@piedras=0
		@papeles=0
		@tijeras=0
		@lagartos=0
		@spocks=0
		@primera=Piedra.new
	end

	def prox(j) #j es la jugada anterior del op
		if j.is_a? Jugada
			if !(@primera.equal? j)
				if j.class == Piedra
					@piedras+=1
				elsif j.class == Papel
					@papeles+=1
				elsif j.class == Tijera
					@tijeras+=1
				elsif j.class == Lagarto
					@lagartos+=1
				elsif j.class == Spock
					@spocks+=1
				end
				#Generate random number
				random = @@r.rand(@piedras+@papeles+@tijeras+@lagartos+@spocks)
				puts "random was #{random} "
				case random
				when 0...@piedras
					return Piedra.new
				when @piedras...@piedras+@papeles
					return Papel.new
				when @piedras+@papeles...@piedras+@papeles+@tijeras
					return Tijera.new
				when @piedras+@papeles+@tijeras...@piedras+@papeles+@tijeras+@lagartos
					return Lagarto.new
				when @piedras+@papeles+@tijeras+@lagartos...@piedras+@papeles+@tijeras+@lagartos+@spocks
					return Spock.new
				end
			else
				return @primera
			end

		else
			raise "#{j} no es una jugada valida."
		end
	end

	def to_s
		str="#{self.class.name} con configuracion:"
		if @piedras==0 && @papeles==0 && @tijeras==0 && @lagartos==0 && @spocks==0
			str.concat"\n No existe un conteo de jugadas anteriores del oponente.\n"
			return str
		end
		str.concat"\n Conteo de jugadas del oponente:\n"
		if @piedras!=0
			if @piedras>1
				str.concat"\tPiedra: #{@piedras} veces.\n"
			else
				str.concat"\tPiedra: #{@piedras} vez.\n"
			end
		end
		if @papeles!=0
			if @papeles>1
				str.concat"\tPapel: #{@papeles} veces.\n"
			else
				str.concat"\tPapel: #{@papeles} vez.\n"
			end
		end
		if @tijeras!=0
			if @tijeras>1
				str.concat"\tTijera: #{@tijeras} veces.\n"
			else
				str.concat"\tTijera: #{@tijeras} vez.\n"
			end
		end
		if @lagartos!=0
			if @lagartos>1
				str.concat"\tLagarto: #{@lagartos} veces.\n"
			else
				str.concat"\tLagarto: #{@lagartos} vez.\n"
			end
		end
		if @spocks!=0
			if @spocks>1
				str.concat"\tSpock: #{@spocks} veces.\n"
			else 
				str.concat"\tSpock: #{@spocks} vez.\n"
			end
		end
		return str
	end

	def reset
		@piedras=0
		@papeles=0
		@tijeras=0
		@lagartos=0
		@spocks=0
	end

end

=begin
#PRUEBA MANUAL
manual = Manual.new
manual.prox(Jugada.new)
puts "#{manual}"

#PRUEBA UNIFORME
uni = Uniforme.new([:Piedra, :Piedra, :Papel, :Tijera, :Tijera])
#uni1 = Uniforme.new([:hola]) #da error, igual que con una lista vacia
puts "#{uni.jugadas}"
proximaj = uni.prox(Jugada.new)
puts "proximaj #{proximaj} clase #{proximaj.class}"
puts " #{uni} "

#PRUEBA SESGADA
ses = Sesgada.new({:Piedra => 2, :Papel=>5, :Papel=>3})
puts "ses #{ses.jugadas}, sum #{ses.sum}, intervals #{ses.intervals}"
jugada = Jugada.new
for i in 0...ses.sum
	puts "jugada #{i} #{ses.prox(jugada)}"
end
puts "#{ses}"

#PRUEBA COPIAR
inicial = Papel.new
cop = Copiar.new(inicial)
puts "jugada inicial #{cop.prox(cop.primera)} y op juega spock"
jugada = Spock.new
puts "jugada #{cop.prox(jugada)} y op juega papel"
jugada = Papel.new
puts "jugada #{cop.prox(jugada)} y op juega lagarto"
jugada = Lagarto.new
puts "jugada #{cop.prox(jugada)} y op juega x cosa"
puts "#{cop}"

#PRUEBA PENSAR
pen = Pensar.new
puts "op juega Papel, jugada inicial #{pen.prox(pen.primera)}"
puts "op juega Papel, jugada #{pen.prox(Papel.new)}"
puts "op juega Piedra, jugada #{pen.prox(Papel.new)}"
puts "op juega Spock, jugada #{pen.prox(Piedra.new)}"
puts "op juega Spock, jugada #{pen.prox(Spock.new)}"
puts "op juega x cosa, jugada #{pen.prox(Spock.new)}"
puts "#{pen}"
pen.reset
puts "#{pen}"
=end