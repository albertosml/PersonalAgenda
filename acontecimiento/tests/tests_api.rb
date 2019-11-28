require 'rspec'
require 'rack/test'
require_relative '../src/app'

include Rack::Test::Methods 

describe App do
    def app
        App
    end

    def acs
        acontecimiento = Acontecimiento.new(titulo: 'Reunión TFG', horainicio: DateTime.new(2020, 02, 03, 12, 45), 
                                        horafin: DateTime.new(2020, 02, 03, 14, 15), creador: 'albertosml', 
                                        horarecuerdo: DateTime.new(2020, 02, 02, 12, 45))
        app.acs.aniadir_acontecimiento(acontecimiento)
    end

    def get_acontecimiento(index)
        app.acs.get(index)
    end

    context "Creando acontecimiento" do
        it 'El acontecimiento se crea' do
            post "/acontecimiento/nuevo", { :creador => "albertosml", :horainicio => "14/02/2020 16:45", 
                                            :titulo => "Reunión TFM" }.to_json
            expect(last_response.status).to eq 200
            expect(last_response.body).to eq JSON.generate({ :msg => "El acontecimiento se ha creado correctamente" })
        end

        it 'El acontecimiento no se crea porque ya existe uno a esa hora' do
            post "/acontecimiento/nuevo", { :creador => "albertosml", :horainicio => "14/02/2020 16:45", 
                                        :horafin => "14/02/2020 15:45", :titulo => "Reunión TFM" }.to_json
            expect(last_response.status).to eq 200
            expect(last_response.body).to eq JSON.generate({ :msg => 
                                                "La hora de fin debe ser posterior a la hora de inicio" })
        end
    end

    it 'El acontecimiento se elimina' do
        # Obtengo contexto (Añado un acontecimiento)
        acs

        post "/acontecimiento/eliminar", { :creador => "albertosml", :horainicio => "03/02/2020 12:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => "El acontecimiento se ha eliminado con éxito" })
    end

    it 'El acontecimiento se restaura' do
        post "/acontecimiento/restaurar", { :creador => "albertosml", :horainicio => "03/02/2020 12:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => "El acontecimiento se ha restaurado con éxito" })
    end

    it 'Se modifica el título del acontecimiento' do
        post "/acontecimiento/modificar_titulo", { :creador => "albertosml", :horainicio => "03/02/2020 12:45", 
                                            :titulo => "Reunión Comisión Master" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                            "El título del acontecimiento se ha modificado con éxito" })

        # Comprobar título
        expect(get_acontecimiento(0).titulo).to eq "Reunión Comisión Master"
    end

    it 'Se modifica la descripción del acontecimiento' do
        post "/acontecimiento/modificar_descripcion", { :creador => "albertosml", :horainicio => "03/02/2020 12:45", 
                                            :descripcion => "Se habla del máster" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                            "La descripción del acontecimiento se ha modificado con éxito" })

        # Comprobar descripción
        expect(get_acontecimiento(0).descripcion).to eq "Se habla del máster"
    end

    it 'Se modifica la hora de inicio del acontecimiento' do
        post "/acontecimiento/modificar_hora_inicio", { :creador => "albertosml", :horainicio => "03/02/2020 12:45", 
                                            :nuevahorainicio => "03/02/2020 14:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                            "La hora de inicio del acontecimiento se ha modificado con éxito" })

        # Comprobar hora de inicio
        expect(get_acontecimiento(0).hora_inicio).to eq DateTime.new(2020, 02, 03, 14, 45)
    end 

    it 'Se modifica la hora de fin del acontecimiento' do
        post "/acontecimiento/modificar_hora_fin", { :creador => "albertosml", :horainicio => "03/02/2020 14:45", 
                                            :nuevahorafin => "03/02/2020 17:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                            "La hora de fin del acontecimiento se ha modificado con éxito" })

        # Comprobar hora de fin
        expect(get_acontecimiento(0).hora_fin).to eq DateTime.new(2020, 02, 03, 17, 45)
    end 

    it 'Se modifica la hora de recuerdo del acontecimiento' do
        post "/acontecimiento/modificar_hora_recuerdo", { :creador => "albertosml", :horainicio => "03/02/2020 14:45", 
                                            :nuevahorarecuerdo => "02/02/2020 17:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                            "La hora de recuerdo del acontecimiento se ha modificado con éxito" })

        # Comprobar hora de recuerdo
        expect(get_acontecimiento(0).hora_recuerdo).to eq DateTime.new(2020, 02, 02, 17, 45)
    end 

    it 'Se cancela el recuerdo del acontecimiento' do
        post "/acontecimiento/cancelar_recordatorio", { :creador => "albertosml", 
                                                :horainicio => "03/02/2020 14:45" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ :msg => 
                                                "El recordatorio de ese acontecimiento se ha cancelado con éxito" })

        # Comprobar que se ha cancelado el recordatorio del acontecimiento
        expect(get_acontecimiento(0).hora_recuerdo).to eq nil
    end

    it 'Se devuelven los acontecimientos del año 2020' do
        post "/acontecimiento/devolver_agenda", { :creador => "albertosml", :fechainicio => "01/01/2020", 
                                            :fechafin => "31/12/2020" }.to_json
        expect(last_response.status).to eq 200

        acontecimiento = get_acontecimiento(0)

        hora_fin = acontecimiento.hora_fin
        if !hora_fin.nil?
            hora_fin = hora_fin.strftime('%d/%m/%Y %H:%M')
        end

        hora_recuerdo = acontecimiento.hora_recuerdo
        if !hora_recuerdo.nil?
            hora_recuerdo = hora_recuerdo.strftime('%d/%m/%Y %H:%M')
        end

        json_esperado = {
            'titulo' => acontecimiento.titulo,
            'descripcion' => acontecimiento.descripcion,
            'horainicio' => acontecimiento.hora_inicio.strftime('%d/%m/%Y %H:%M'),
            'horafin' => hora_fin,
            'creador' => acontecimiento.creador,
            'horarecuerdo' => hora_recuerdo,
            'eliminado' => acontecimiento.eliminado
        }

        expect(last_response.body).to eq JSON.generate({ :agenda => [json_esperado] })
    end

    it 'Se repite un acontecimiento' do
        post "/acontecimiento/repetir", { :creador => "albertosml", :horainicio => "03/02/2020 14:45", 
                                    :frecuencia => 2, :fechafin => "11/02/2020" }.to_json
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq JSON.generate({ "msg" => "El acontecimiento se ha repetido con éxito" })

        # Comprobar que se ha repetido el evento
        expect(app.acs.num_acontecimientos).to eq 2
        expect(get_acontecimiento(0).hora_inicio).to eq DateTime.new(2020, 02, 03, 14, 45)
        expect(get_acontecimiento(1).hora_inicio).to eq DateTime.new(2020, 02, 10, 14, 45)
    end
end