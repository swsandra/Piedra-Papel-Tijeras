#Clase que representa una jugada
class Jugada

	attr_reader :pierde #accessor (getter and setter)
	
	@pierde=[]

	def to_s
		"#{self.class.name}"
	end

	def puntos(j)
		if j.is_a? Jugada
			if self.class ==  j.class
				return [0, 0]
			elsif self.pierde.include? j.class.name
				return [0, 1]
			else
				return [1, 0]
			end
		else
			raise "#{j} no es una jugada valida."
		end
	end
end

class Piedra < Jugada

	def initialize
		@pierde=["Papel","Spock"]
	end	

end

class Papel < Jugada

	def initialize
		@pierde=["Tijera","Lagarto"]
	end

end

class Tijera < Jugada

	def initialize
		@pierde=["Piedra","Spock"]
	end

end

class Lagarto < Jugada

	def initialize
		@pierde=["Piedra","Tijera"]
	end

end

class Spock < Jugada

	def initialize
		@pierde=["Papel","Lagarto"]
	end

end

=begin
jugada = Piedra.new
puts " #{jugada} "
puts " #{jugada.pierde} "
puts "#{jugada.puntos(Spock.new)}"
puts "#{!(jugada.is_a? Jugada)}"
=end