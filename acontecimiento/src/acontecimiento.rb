require 'date'

class Acontecimiento
    # Métodos get
    attr_reader :titulo, :descripcion, :hora_inicio, :hora_fin, :creador, :hora_recuerdo

    # Custom error
    class AcontecimientoError < StandardError; end

	# Constructor
	def initialize(titulo:, descripcion: nil, horainicio:, horafin: nil, creador:, horarecuerdo: nil)
		# Atributos
		@titulo = titulo
		@descripcion = descripcion
        @hora_inicio = horainicio
        @hora_fin = horafin
        @creador = creador
        @hora_recuerdo = horarecuerdo

        check_acontecimiento
    end
    
    private
    def check_acontecimiento
        # La fecha del acontecimiento es anterior al momento actual
        if @hora_inicio <= DateTime.now
            raise AcontecimientoError, "No se pueden crear acontecimientos con una fecha pasada"
        end
            
        # La hora de inicio debe ser anterior a la hora de fin
        if !@hora_fin.nil? && @hora_fin < @hora_inicio
            raise AcontecimientoError, "La hora de fin debe ser posterior a la hora de inicio"
        end

        # La hora de recuerdo debe ser anterior a la hora de inicio
        if !@hora_recuerdo.nil? && @hora_recuerdo > @hora_inicio
            raise AcontecimientoError, "La fecha de recuerdo debe ser anterior a la hora de inicio"
        end
    end
end