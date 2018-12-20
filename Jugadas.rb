#Clase que representa una jugada
class Jugada
	
	@pierde=[]

	def to_s
		"#{self.class.name}"
	end

	def puntos(jugada)
		#self.class.pierde.include? j.class.name
		#self.class == j.class
	end

	attr_reader :pierde #accessor (getter and setter)

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

jugada = Piedra.new
puts " #{jugada} "
puts " #{jugada.pierde} "
puts "#{jugada.class==Piedra}" # .is_a?