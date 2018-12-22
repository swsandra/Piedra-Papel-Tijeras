##
# Clase que representa una jugada de Piedra, Papel, Tijera, Lagarto, Spock.
class Jugada

	##
	# Arreglo que contiene los nombres de las clases contra las cuales la instancia de Jugada pierde.
	attr_reader :pierde
	
	@pierde=[]

	##
	# Método que retorna la representación en string de una Jugada.
	def to_s
		"#{self.class.name}"
	end

	##
	# Método que dada una jugada +j+ determina los puntos en relación a 
	# la instancia Jugada sobre la cual es llamada:
	#
	# Empatar retorna [0,0]
	#
	# Ganar retorna [1,0]
	#
	# Perder retorna [0,1]
	#
	# En caso de que +j+ no sea una jugada válida, se genera una excepción.

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

##
# Clase que representa una Jugada de tipo Piedra.
class Piedra < Jugada

	##
	# Método que inicializa una Jugada de tipo Piedra.
	def initialize
		@pierde=["Papel","Spock"]
	end	

end

##
# Clase que representa una Jugada de tipo Papel.
class Papel < Jugada

	##
	# Método que inicializa una Jugada de tipo Papel.
	def initialize
		@pierde=["Tijera","Lagarto"]
	end

end

##
# Clase que representa una Jugada de tipo Tijera.
class Tijera < Jugada

	##
	# Método que inicializa una Jugada de tipo Tijera.
	def initialize
		@pierde=["Piedra","Spock"]
	end

end

##
# Clase que representa una Jugada de tipo Lagarto.
class Lagarto < Jugada

	##
	# Método que inicializa una Jugada de tipo Lagarto.
	def initialize
		@pierde=["Piedra","Tijera"]
	end

end

##
# Clase que representa una Jugada de tipo Spock.
class Spock < Jugada

	##
	# Método que inicializa una Jugada de tipo Spock.
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