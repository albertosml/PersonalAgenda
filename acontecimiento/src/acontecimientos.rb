require_relative 'acontecimiento'

class Acontecimientos
    def initialize
        @acontecimientos = []
    end

    def aniadir_acontecimiento(acontecimiento)
        if self.num_acontecimientos == 0 || acontecimiento.eliminado || !comprobar_solapamiento(acontecimiento)
            @acontecimientos << acontecimiento
        end
    end

    def num_acontecimientos
        @acontecimientos.length
    end

    def restaurar(creador, hora_inicio)
        acon = obtener_acontecimiento(creador, hora_inicio)

        if !acon.eliminado
            raise Acontecimiento::AcontecimientoError, "El acontecimiento ya se encuentra restaurado"
        end

        if comprobar_solapamiento(acon)
            raise Acontecimiento::AcontecimientoError, "No se puede restaurar el acontecimiento porque hay otro solapándolo en ese momento"
        else
            acon.restaurar
        end
    end

    def modificar_hora_inicio(creador, hora_inicio, nueva_hora_inicio)
        acon = obtener_acontecimiento(creador, hora_inicio)

        if acon.eliminado
            raise Acontecimiento::AcontecimientoError, "El acontecimiento está eliminado, por lo que no se puede modificar su hora de inicio"
        end

        acon.modificar_hora_inicio(nueva_hora_inicio, comprobar=false)
        if comprobar_solapamiento(acon)
            acon.modificar_hora_inicio(hora_inicio)
            raise Acontecimiento::AcontecimientoError, "Ya tiene otro acontecimiento en ese instante"
        else 
            diferencia_tiempo = nueva_hora_inicio - hora_inicio

            if acon.hora_inicio < acon.hora_recuerdo
                acon.cancelar_recordatorio
            end

            nueva_hora_fin = acon.hora_fin + diferencia_tiempo
            acon.modificar_hora_fin(nueva_hora_fin)
        end
    end

    def modificar_hora_fin(creador, hora_inicio, nueva_hora_fin)
        acon = obtener_acontecimiento(creador, hora_inicio)
        
        if acon.eliminado
            raise Acontecimiento::AcontecimientoError, "El acontecimiento está eliminado, por lo que no se puede modificar su hora de inicio"
        end

        antigua_hora_fin = acon.hora_fin

        acon.modificar_hora_fin(nueva_hora_fin)

        if comprobar_solapamiento(acon, prin=true)
            acon.modificar_hora_fin(antigua_hora_fin)
            raise Acontecimiento::AcontecimientoError, "Ya tiene otro acontecimiento en ese instante"
        end
    end

    def devolver_agenda(creador, fecha_inicio, fecha_fin)
        # Ponemos la fecha de fin a las 00:00 del día siguiente para incluir los acontecimientos que estén en el 
        # mismo día que la fecha de fin 
        fecha_fin += 1

        @acontecimientos.select do |acon|
            acon.creador == creador && fecha_inicio <= acon.hora_inicio && acon.hora_inicio < fecha_fin && !acon.eliminado
        end
    end

    def repetir_evento(creador, hora_inicio, opcion, fecha_fin)
        acon = obtener_acontecimiento(creador, hora_inicio)

        if acon.eliminado
            raise Acontecimiento::AcontecimientoError, "No se puede repetir un evento eliminado"
        end

        ## Ponemos la fecha de fin a las 00:00 del día siguiente para repetir acontecimientos en la fecha de fin
        fecha_fin += 1

        while hora_inicio <= fecha_fin do
            hora_inicio, hora_recuerdo, hora_fin = calcular_nuevas_horas(opcion, acon)

            if hora_inicio > fecha_fin
                break
            end 

            acon = Acontecimiento.new(titulo: acon.titulo, descripcion: acon.descripcion, horainicio: hora_inicio,
                                        horafin: hora_fin, creador: creador, horarecuerdo: hora_recuerdo)
            aniadir_acontecimiento(acon)
        end
    end

    def get(index)
        @acontecimientos[index]
    end

    private
    def calcular_nuevas_horas(opcion, acon)
        # Calculo nuevas horas de inicio y recuerdo en base a la opción
        hora_recuerdo = acon.hora_recuerdo

        # Diariamente
        if opcion == 1 
            hora_inicio = acon.hora_inicio + 1
            
            if !acon.hora_recuerdo.nil?
                hora_recuerdo += 1
            end
        # Semanalmente
        elsif opcion == 2 
            hora_inicio = acon.hora_inicio + 7

            if !acon.hora_recuerdo.nil?
                hora_recuerdo += 7
            end
        # Mensualmente
        else 
            hora_inicio = acon.hora_inicio >> 1
            
            if !acon.hora_recuerdo.nil?
                hora_recuerdo >> 1
            end
        end    

        # Calculo la nueva hora de fin en base a la nueva hora de inicio
        diferencia_tiempo = acon.hora_fin - acon.hora_inicio
        hora_fin = hora_inicio + diferencia_tiempo

        return hora_inicio, hora_recuerdo, hora_fin
    end

    def obtener_acontecimiento(creador, hora_inicio)
        acon = @acontecimientos.find {|acon| acon.creador == creador && acon.hora_inicio == hora_inicio }

        if acon == nil
            raise Acontecimiento::AcontecimientoError, "No se ha encontrado un acontecimiento con esas características"
        end

        acon
    end

    def acontecimientos_creador(creador)
        @acontecimientos.select do |acon|
            acon.creador == creador && !acon.eliminado
        end
    end

    def comprobar_solapamiento(acontecimiento, prin=false)
        for acon in acontecimientos_creador(acontecimiento.creador) do
            if acon == acontecimiento
                next
            end

            if acon.hora_fin.nil? && acontecimiento.hora_fin.nil?
                if acon.hora_inicio == acontecimiento.hora_inicio
                    return true
                end
            elsif acon.hora_fin.nil?    
                if comprobar_solapamiento_sin_hora_fin(acontecimiento.hora_inicio, acontecimiento.hora_fin, acon.hora_inicio)
                    return true
                end 
            elsif acontecimiento.hora_fin.nil?
                if comprobar_solapamiento_sin_hora_fin(acon.hora_inicio, acon.hora_fin, acontecimiento.hora_inicio)
                    return true
                end 
            else 
                if comprobar_solapamiento_con_hora_fin(acon.hora_inicio, acon.hora_fin, acontecimiento.hora_inicio,acontecimiento.hora_fin)
                    return true
                end
            end
        end

        false
    end

    def comprobar_solapamiento_con_hora_fin(ac1_hora_inicio, ac1_hora_fin, ac2_hora_inicio, ac2_hora_fin)
        # Si la hora de inicio está entre la hora de inicio y de fin del otro acontecimiento
        if ac1_hora_inicio <= ac2_hora_inicio && ac2_hora_inicio <= ac1_hora_fin
            return true
        end

        # Si la hora de fin está entre la hora de inicio y de fin del otro acontecimiento
        if ac1_hora_inicio <= ac2_hora_fin && ac2_hora_fin <= ac1_hora_fin
            return true
        end         
        
        # Si la hora de inicio y fin del otro acontecimiento están en el intervalo del nuevo evento
        if ac2_hora_inicio <= ac1_hora_inicio && ac1_hora_fin <= ac2_hora_fin
            return true
        end

        false
    end

    def comprobar_solapamiento_sin_hora_fin(ac1_hora_inicio, ac1_hora_fin, ac2_hora_inicio)
        # Comprobar si la hora de inicio está entre la hora de inicio y la de fin
        ac1_hora_inicio <= ac2_hora_inicio && ac2_hora_inicio <= ac1_hora_fin
    end
end
