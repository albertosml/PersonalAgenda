require 'date'

class Acontecimiento
    # Métodos get
    attr_reader :titulo, :descripcion, :hora_inicio, :hora_fin, :creador, :hora_recuerdo, :eliminado

    # Custom error
    class AcontecimientoError < StandardError; end

	# Constructor
	def initialize(titulo:, descripcion: nil, horainicio:, horafin: nil, creador:, horarecuerdo: nil, eliminado: false)
		# Atributos
		@titulo = titulo
		@descripcion = descripcion
        @hora_inicio = horainicio
        @hora_fin = horafin
        @creador = creador
        @hora_recuerdo = horarecuerdo
        @eliminado = eliminado

        comprobar_acontecimiento
    end

    def eliminar
        if @eliminado
            raise AcontecimientoError, "El acontecimiento ya se encuentra eliminado"
        end

        @eliminado = true
    end

    def restaurar
        if !@eliminado
            raise AcontecimientoError, "El acontecimiento ya se encuentra restaurado"
        end

        @eliminado = false
    end

    def modificar_titulo(titulo)
        @titulo = titulo
    end

    def modificar_descripcion(descripcion)
        @descripcion = descripcion
    end

    def modificar_hora_inicio(hora_inicio, comprobar=true)
        @hora_inicio = hora_inicio
        if comprobar
            comprobar_acontecimiento
        end
    end

    def modificar_hora_fin(hora_fin)
        @hora_fin = hora_fin
        comprobar_acontecimiento
    end

    def modificar_hora_recuerdo(hora_recuerdo)
        if !hora_recuerdo.nil? && hora_recuerdo > @hora_inicio
            raise AcontecimientoError, "No se puede introducir una fecha de recuerdo posterior al acontecimiento"
        else
            @hora_recuerdo = hora_recuerdo
            comprobar_acontecimiento
        end
    end

    def cancelar_recordatorio
        modificar_hora_recuerdo(nil)
    end
    
    private
    def comprobar_acontecimiento
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

        if !es_dia_laboral
            raise AcontecimientoError, "No se puede insertar un acontecimiento en un día no laboral"
        end
    end

    def es_dia_laboral
        true
    end
end