require_relative 'acontecimiento'
require_relative 'acontecimientos'
require 'json'
require 'date'
require 'sinatra'

class App < Sinatra::Base

    # Lista de acontecimientos
    @@acs = Acontecimientos.new

    def self.acs
        @@acs
    end

    # Ruta para crear un nuevo acontecimiento
    post '/acontecimiento/nuevo' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        titulo = params['titulo']
        descripcion = params['descripcion']
        horainicio = params['horainicio']
        horafin = params['horafin']
        creador = params['creador']
        horarecuerdo = params['horarecuerdo']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')

        # Formateo hora de fin
        if !horafin.nil?
            horafin = DateTime.strptime(horafin, '%d/%m/%Y %H:%M')
        end

        begin
            # Crear el acontecimiento
            acontecimiento = Acontecimiento.new(titulo: titulo, descripcion: descripcion, horainicio: horainicio, 
                                                horafin: horafin, creador: creador, horarecuerdo: horarecuerdo)

            # Añadir acontecimiento a la lista de acontecimientos
            @@acs.aniadir_acontecimiento(acontecimiento)

            body JSON.generate({ "msg" => "El acontecimiento se ha creado correctamente" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })
        end
    end

    # Ruta para eliminar un acontecimiento
    post '/acontecimiento/eliminar' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Obtener el acontecimiento con ese creador y esa hora de inicio
            acontecimiento = @@acs.obtener_acontecimiento(creador, horainicio)

            # Eliminar el acontecimiento
            acontecimiento.eliminar

            body JSON.generate({ "msg" => "El acontecimiento se ha eliminado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            puts ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para restaurar un acontecimiento ya eliminado
    post '/acontecimiento/restaurar' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Restaurar el acontecimiento con ese creador y esa hora de inicio
            @@acs.restaurar(creador, horainicio)

            body JSON.generate({ "msg" => "El acontecimiento se ha restaurado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para modificar el título de un acontecimiento
    post '/acontecimiento/modificar_titulo' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        nuevo_titulo = params['titulo']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Obtener el acontecimiento con ese creador y esa hora de inicio
            acontecimiento = @@acs.obtener_acontecimiento(creador, horainicio)

            # Modificar el título del acontecimiento
            acontecimiento.modificar_titulo(nuevo_titulo)

            body JSON.generate({ "msg" => "El título del acontecimiento se ha modificado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para modificar la descripción de un acontecimiento
    post '/acontecimiento/modificar_descripcion' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        nueva_descripcion = params['descripcion']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Obtener el acontecimiento con ese creador y esa hora de inicio
            acontecimiento = @@acs.obtener_acontecimiento(creador, horainicio)

            # Modificar la descripción del acontecimiento
            acontecimiento.modificar_descripcion(nueva_descripcion)

            body JSON.generate({ "msg" => "La descripción del acontecimiento se ha modificado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para modificar la hora de inicio de un acontecimiento
    post '/acontecimiento/modificar_hora_inicio' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        nuevahorainicio = params['nuevahorainicio']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')

        # Formateo nueva hora de inicio
        nuevahorainicio = DateTime.strptime(nuevahorainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Modificar la hora de inicio del acontecimiento con ese creador y esa hora de inicio
            @@acs.modificar_hora_inicio(creador, horainicio, nuevahorainicio)

            body JSON.generate({ "msg" => "La hora de inicio del acontecimiento se ha modificado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para modificar la hora de fin de un acontecimiento
    post '/acontecimiento/modificar_hora_fin' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        nuevahorafin = params['nuevahorafin']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')

        # Formateo nueva hora de fin
        nuevahorafin = DateTime.strptime(nuevahorafin, '%d/%m/%Y %H:%M')
        
        begin
            # Modificar la hora de fin del acontecimiento con ese creador y esa hora de inicio
            @@acs.modificar_hora_fin(creador, horainicio, nuevahorafin)

            body JSON.generate({ "msg" => "La hora de fin del acontecimiento se ha modificado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })    
        end
    end

    # Ruta para modificar la hora de recuerdo de un acontecimiento
    post '/acontecimiento/modificar_hora_recuerdo' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        nuevahorarecuerdo = params['nuevahorarecuerdo']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')

        # Formateo nueva hora de recuerdo
        nuevahorarecuerdo = DateTime.strptime(nuevahorarecuerdo, '%d/%m/%Y %H:%M')
        
        begin
            # Obtener el acontecimiento con ese creador y esa hora de inicio
            acontecimiento = @@acs.obtener_acontecimiento(creador, horainicio)

            # Modificar la hora de recuerdo del acontecimiento con ese creador y esa hora de inicio
            acontecimiento.modificar_hora_recuerdo(nuevahorarecuerdo)

            body JSON.generate({ "msg" => "La hora de recuerdo del acontecimiento se ha modificado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })
        end
    end

    # Ruta para cancelar el recordatorio de un acontecimiento
    post '/acontecimiento/cancelar_recordatorio' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        begin
            # Obtener el acontecimiento con ese creador y esa hora de inicio
            acontecimiento = @@acs.obtener_acontecimiento(creador, horainicio)

            # Cancelar el recuerdo de ese acontecimiento
            acontecimiento.cancelar_recordatorio

            body JSON.generate({ "msg" => "El recordatorio de ese acontecimiento se ha cancelado con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })
        end
    end

    # Ruta para devolver la agenda de acontecimientos entre 2 fechas
    post '/acontecimiento/devolver_agenda' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        fechainicio = params['fechainicio']
        fechafin = params['fechafin']
        creador = params['creador']

        # Formateo fecha de inicio
        fechainicio = DateTime.strptime(fechainicio, '%d/%m/%Y')

        # Formateo fecha de fin
        fechafin = DateTime.strptime(fechafin, '%d/%m/%Y')
        
        begin
            # Obtener los acontecimientos de ese creador entre la fecha de inicio y la de fin (ambas incluidas)
            agenda = @@acs.devolver_agenda(creador, fechainicio, fechafin)

            body JSON.generate({ "agenda" => agenda })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })
        end
    end

    # Ruta para repetir un acontecimiento
    post '/acontecimiento/repetir' do
        # Obtener parámetros
        params = JSON.parse(request.body.read)
        horainicio = params['horainicio']
        creador = params['creador']
        frecuencia = params['frecuencia']
        fechafin = params['fechafin']

        # Formateo hora de inicio
        horainicio = DateTime.strptime(horainicio, '%d/%m/%Y %H:%M')
        
        # Formateo fecha de fin
        fechafin = DateTime.strptime(fechafin, '%d/%m/%Y')
        
        begin
            # Repetir los acontecimientos de ese creador y esa fecha de inicio
            @@acs.repetir_evento(creador, horainicio, frecuencia, fechafin)

            body JSON.generate({ "msg" => "El acontecimiento se ha repetido con éxito" })
        rescue Acontecimiento::AcontecimientoError => ae
            body JSON.generate({ "msg" => ae.message })
        rescue StandardError => e
            body JSON.generate({ "msg" => e.message })
        end
    end

end