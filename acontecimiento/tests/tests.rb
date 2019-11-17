require 'rspec'
require 'date'
require_relative '../src/acontecimiento'
require_relative '../src/acontecimientos'

describe Acontecimiento do
    let(:acontecimiento) { Acontecimiento.new(titulo: 'Reunión TFM Máster', descripcion: 'Se va a hablar del TFM', 
                                            horainicio: DateTime.new(2020, 02, 03, 12, 45), 
                                            horafin: DateTime.new(2020, 02, 03, 14, 15),
                                            creador: '@albertosml', horarecuerdo: DateTime.new(2020, 02, 02, 12, 45)) }

    context "Creando acontecimiento" do
        context "El acontecimiento se crea" do
            it 'El acontecimiento tiene su título' do
                expect(acontecimiento.titulo).to eq 'Reunión TFM Máster'
            end

            it 'El acontecimiento tiene su descripción' do
                expect(acontecimiento.descripcion).to eq 'Se va a hablar del TFM'
            end

            it 'El acontecimiento tiene su hora de inicio' do
                expect(acontecimiento.hora_inicio).to eq DateTime.new(2020, 02, 03, 12, 45)
            end

            it 'El acontecimiento tiene su hora de fin' do
                expect(acontecimiento.hora_fin).to eq DateTime.new(2020, 02, 03, 14, 15)
            end

            it 'El acontecimiento tiene asociado un creador' do
                expect(acontecimiento.creador).to eq '@albertosml'
            end


            it 'El acontecimiento tiene una hora de recuerdo' do
                expect(acontecimiento.hora_recuerdo).to eq DateTime.new(2020, 02, 02, 12, 45)
            end
        end

        it 'El acontecimiento se crea sin descripción' do
            acontecimiento = Acontecimiento.new(titulo: 'Reunión TFM Máster', 
                                                horainicio: DateTime.new(2020, 03, 03, 12, 45), 
                                                horafin: DateTime.new(2020, 03, 03, 14, 15),
                                                creador: '@albertosml', horarecuerdo: DateTime.new(2020, 03, 02, 12, 45))
            expect(acontecimiento.descripcion).to eq nil
        end

        it 'El acontecimiento se crea sin hora de fin' do
            acontecimiento = Acontecimiento.new(titulo: 'Reunión TFM Máster', descripcion: 'Se va a hablar del TFM', 
                                                horainicio: DateTime.new(2020, 03, 03, 12, 45), 
                                                creador: '@albertosml', horarecuerdo: DateTime.new(2020, 03, 02, 12, 45))
            expect(acontecimiento.hora_fin).to eq nil
        end

        it 'El acontecimiento se crea sin fecha de recuerdo' do
            acontecimiento = Acontecimiento.new(titulo: 'Reunión TFM Máster', descripcion: 'Se va a hablar del TFM', 
                                                horainicio: DateTime.new(2020, 03, 03, 12, 45),
                                                horafin: DateTime.new(2020, 03, 03, 14, 15), creador: '@albertosml')
            expect(acontecimiento.hora_recuerdo).to eq nil
        end

        it 'No se puede crear un acontecimiento con fecha anterior a la de hoy' do
            expect { Acontecimiento.new(titulo:'Reunión TFG', horainicio: DateTime.new(2017, 02, 03, 12, 45), creador: 
            '@albertosml') }.to raise_error(Acontecimiento::AcontecimientoError, 
            "No se pueden crear acontecimientos con una fecha pasada")
        end

        it 'La hora de inicio debe ser anterior a la hora de fin' do
            expect { Acontecimiento.new(titulo: 'Reunión TFG', horainicio: DateTime.new(2020, 03, 03, 12, 45), horafin:
            DateTime.new(2019, 03, 03, 10, 45), creador: '@albertosml') }.to raise_error(
            Acontecimiento::AcontecimientoError, "La hora de fin debe ser posterior a la hora de inicio")
        end

        it 'La hora de recuerdo debe ser anterior a la hora de inicio' do
            expect { Acontecimiento.new(titulo: 'Reunión TFG', horainicio: DateTime.new(2020, 03, 03, 12, 45), creador:
            '@albertosml', horarecuerdo: DateTime.new(2020, 03, 03, 15, 45)) }.to raise_error(
            Acontecimiento::AcontecimientoError, "La fecha de recuerdo debe ser anterior a la hora de inicio")
        end

        it 'No se puede crear un acontecimiento a una hora ya ocupada' do
            # Se ha insertado un acontecimiento
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            expect(acs.num_acontecimientos).to eq 1

            # El acontecimiento se solapa por lo que no se inserta
            acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Reunión TFG', creador: '@albertosml',
                                                        horainicio: DateTime.new(2020, 02, 03, 13, 45), 
                                                        horafin: DateTime.new(2020, 02, 03, 15, 45)))
            expect(acs.num_acontecimientos).to eq 1

            # Se crea un nuevo acontecimiento que no solapa al otro y se inserta
            acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Reunión TFG', creador: '@albertosml',
                                                        horainicio: DateTime.new(2020, 02, 03, 14, 45), 
                                                        horafin: DateTime.new(2020, 02, 03, 15, 45)))
            expect(acs.num_acontecimientos).to eq 2


            # El acontecimiento se solapa, pero al ser de otro usuario se inserta
            acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Reunión TFG', creador: '@JJ',
                                                        horainicio: DateTime.new(2020, 02, 03, 13, 45), 
                                                        horafin: DateTime.new(2020, 02, 03, 15, 45)))
            expect(acs.num_acontecimientos).to eq 3
        end

        it 'No se puede crear un acontecimiento en un día no laboral para esa persona' do
            # Simular día no laboral
            allow_any_instance_of(Acontecimiento).to receive(:es_dia_laboral).and_return(false)

            expect { Acontecimiento.new(titulo: 'Reunión TFG', creador: '@albertosml', horainicio: 
            DateTime.new(2020, 02, 03, 14, 45), horafin: DateTime.new(2020, 02, 03, 15, 45)) }.to raise_error(
            Acontecimiento::AcontecimientoError, "No se puede insertar un acontecimiento en un día no laboral")
        end
    end

    context 'Eliminando acontecimiento' do
        it 'El acontecimiento cambia a estado eliminado' do
            expect(acontecimiento.eliminado).to be false
            acontecimiento.eliminar
            expect(acontecimiento.eliminado).to be true
        end

        it 'El acontecimiento se encuentra ya eliminado' do
            expect(acontecimiento.eliminado).to be false
            acontecimiento.eliminar
            expect(acontecimiento.eliminado).to be true

            # Si lo vuelvo a eliminar, no podré hacerlo porque ya lo he hecho
            expect { acontecimiento.eliminar }.to raise_error(Acontecimiento::AcontecimientoError, 
            "El acontecimiento ya se encuentra eliminado")
        end
    end

    context 'Restaurando acontecimiento' do
        it 'El acontecimiento eliminado cambia a estado no eliminado' do
            acontecimiento.eliminar
            expect(acontecimiento.eliminado).to be true

            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            acs.restaurar(acontecimiento.creador, acontecimiento.hora_inicio)

            expect(acontecimiento.eliminado).to be false
        end

        it 'El acontecimiento se encuentra ya restaurado' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)

            expect { acs.restaurar(acontecimiento.creador, acontecimiento.hora_inicio) }.to raise_error(
                Acontecimiento::AcontecimientoError, "El acontecimiento ya se encuentra restaurado")
        end

        it 'El acontecimiento no se puede restaurar debido a que hay otro acontecimiento solapándolo' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            
            acon = Acontecimiento.new(titulo: 'Examen CC', horainicio: DateTime.new(2020, 02, 03, 13, 00), 
                                        creador: '@albertosml', eliminado: true)            
            acs.aniadir_acontecimiento(acon)

            expect { acs.restaurar(acon.creador, acon.hora_inicio) }.to raise_error(Acontecimiento::AcontecimientoError,
            "No se puede restaurar el acontecimiento porque hay otro solapándolo en ese momento")
        end

        it 'El acontecimiento a restaurar no existe' do
            acs = Acontecimientos.new
            
            expect { acs.restaurar(acontecimiento.creador, acontecimiento.hora_inicio) }.to raise_error(
                Acontecimiento::AcontecimientoError,  "No se ha encontrado un acontecimiento con esas características")
        end
    end

    it 'Se modifica el título del acontecimiento' do
        expect(acontecimiento.titulo).to eq 'Reunión TFM Máster'
        acontecimiento.modificar_titulo('Congreso de software libre')
        expect(acontecimiento.titulo).to eq 'Congreso de software libre'
    end

    it 'Se modifica la descripción del acontecimiento' do
        expect(acontecimiento.descripcion).to eq 'Se va a hablar del TFM'
        acontecimiento.modificar_descripcion('El objetivo es fomentar el software libre')
        expect(acontecimiento.descripcion).to eq 'El objetivo es fomentar el software libre'
    end

    context 'Se modifica la hora de inicio del acontecimiento' do
        it 'Al haber otro acontecimiento a esa hora para esa persona, la hora de inicio no se ve alterada' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            expect(acontecimiento.hora_inicio).to eq DateTime.new(2020, 02, 03, 12, 45)

            # Simulo otro acontecimiento
            acon = Acontecimiento.new(titulo: 'Clase CC', descripcion: 'Charla de JJ', 
                                    horainicio: DateTime.new(2020, 02, 03, 16, 45),
                                    horafin: DateTime.new(2020, 02, 03, 18, 15), creador: '@albertosml')
            acs.aniadir_acontecimiento(acon)

            # Modifico la hora de inicio a una solapada
            expect { acs.modificar_hora_inicio('@albertosml', DateTime.new(2020, 02, 03, 16, 45),    
                        DateTime.new(2020, 02, 03, 13, 45)) }.to raise_error(Acontecimiento::AcontecimientoError, 
                        "Ya tiene otro acontecimiento en ese instante")
            expect(acon.hora_inicio).to eq DateTime.new(2020, 02, 03, 16, 45)
        end

        it 'A esa hora no hay otro acontecimiento y por tanto se puede cambiar el ítem a esa nueva hora, modificándose 
        también la hora inicio y mánteniéndose la fecha de recuerdo al ser menor que la hora de inicio' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            expect(acontecimiento.hora_inicio).to eq DateTime.new(2020, 02, 03, 12, 45)
        
            acs.modificar_hora_inicio('@albertosml', DateTime.new(2020, 02, 03, 12, 45), 
                                            DateTime.new(2020, 02, 03, 14, 45))
            expect(acontecimiento.hora_inicio).to eq DateTime.new(2020, 02, 03, 14, 45)
        
            # Al modificarse la hora de inicio del acontecimiento, la hora de fin también se ve alterada' do
            expect(acontecimiento.hora_fin).to eq DateTime.new(2020, 02, 03, 16, 15)
            
            # La fecha de recuerdo se mantiene al ser anterior a la nueva hora' do
            expect(acontecimiento.hora_recuerdo).to eq DateTime.new(2020, 02, 02, 12, 45)
        end
        
        it 'Si la fecha de recuerdo es posterior a la nueva hora de inicio del evento, esta se elimina' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            acs.modificar_hora_inicio(acontecimiento.creador, acontecimiento.hora_inicio, 
                                        DateTime.new(2020, 02, 01, 14, 45))
            expect(acontecimiento.hora_recuerdo).to eq nil
        end
    end

    context 'Se modifica la fecha de fin del acontecimiento' do
        it 'Al haber otro evento a esa hora, la hora de fin no se ve alterada' do
            # Simulo otro acontecimiento que solape al final
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            
            acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Clase CC', descripcion: 'Charla de JJ', 
                                horainicio: DateTime.new(2020, 02, 03, 16, 45), horafin: DateTime.new(2020, 02, 03, 17, 15), 
                                creador: '@albertosml'))

            expect(acs.num_acontecimientos).to eq 2

            expect { acs.modificar_hora_fin('@albertosml', DateTime.new(2020, 02, 03, 12, 45), DateTime.new(2020, 02, 03, 16, 50)) }.to raise_error(Acontecimiento::AcontecimientoError, "Ya tiene otro acontecimiento en ese instante")
        end

        it 'En ese instante no hay otro acontecimiento y por tanto se puede cambiar la hora de fin' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)

            expect(acontecimiento.hora_fin).to eq DateTime.new(2020, 02, 03, 14, 15)

            acs.modificar_hora_fin('@albertosml', DateTime.new(2020, 02, 03, 12, 45), DateTime.new(2020, 02, 03, 16, 50))
            
            expect(acontecimiento.hora_fin).to eq DateTime.new(2020, 02, 03, 16, 50)
        end
    end

    context 'Se modifica la fecha de recuerdo' do
        it 'Al introducir una fecha de recuerdo posterior al acontecimiento, esta no se vería modificada' do
            expect(acontecimiento.hora_recuerdo).to eq DateTime.new(2020, 02, 02, 12, 45)
            expect { acontecimiento.modificar_hora_recuerdo(DateTime.new(2020, 02, 06, 12, 45)) }.to raise_error(
                Acontecimiento::AcontecimientoError, "No se puede introducir una fecha de recuerdo posterior al acontecimiento")
        end

        it 'Si la fecha de recuerdo es anterior al acontecimiento, se puede modificar' do 
            acontecimiento.modificar_hora_recuerdo(DateTime.new(2020, 02, 02, 13, 45))
            expect(acontecimiento.hora_recuerdo).to eq DateTime.new(2020, 02, 02, 13, 45)
        end
    end

    it 'Se cancela un recordatorio' do 
        acontecimiento.cancelar_recordatorio()
        expect(acontecimiento.hora_recuerdo).to eq nil
    end

    it 'Devolver la agenda personal entre 2 fechas (Año 2021)' do
        acs = Acontecimientos.new
        acs.aniadir_acontecimiento(acontecimiento)

        # Acontecimiento en 2021 eliminado
        acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Clase DSS', horainicio: DateTime.new(2021, 04, 03, 16, 45), 
                                creador: '@albertosml', eliminado: true))

        # Acontecimiento en 2021
        acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Clase CC', horainicio: DateTime.new(2021, 12, 31, 16, 45), 
                                creador: '@albertosml'))

        # Acontecimiento futuro a 2021
        acs.aniadir_acontecimiento(Acontecimiento.new(titulo: 'Clase TID', horainicio: DateTime.new(2022, 12, 31, 16, 45), 
                                creador: '@albertosml'))

        # Solo se devolvería el acontecimiento en 2021 que no está eliminado
        agenda = acs.devolver_agenda('@albertosml', DateTime.new(2021, 01, 01), DateTime.new(2021, 12, 31))
        expect(agenda.length).to eq 1
    end 

    context 'Se repite el evento' do
        it 'No se puede repetir el evento porque ya hay uno existente ese día' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)
            
            acon = Acontecimiento.new(titulo: 'Reunión', horainicio: acontecimiento.hora_inicio + 1, creador: '@albertosml')
            acs.aniadir_acontecimiento(acon)

            # Hay 2 acontecimientos
            expect(acs.num_acontecimientos).to eq 2

            # Repito evento mañana
            acs.repetir_evento(acontecimiento.creador, acontecimiento.hora_inicio, 1, DateTime.new(2020, 02, 04))

            # Seguirá habiendo 2 acontecimientos ya que el otro no se va a repetir
            expect(acs.num_acontecimientos).to eq 2
        end
        
        it 'Se repite el evento diariamente' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)

            # Hay 1 acontecimiento
            expect(acs.num_acontecimientos).to eq 1

            # Repito evento mañana
            acs.repetir_evento(acontecimiento.creador, acontecimiento.hora_inicio, 1, DateTime.new(2020, 02, 04))

            # Hay 1 acontecimiento más
            expect(acs.num_acontecimientos).to eq 2

            # Ese será un día después al otro
            expect(acs.get(1).hora_inicio).to eq DateTime.new(2020, 02, 04, 12, 45)
        end

        it 'Se repite el evento semanalmente' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)

            # Hay 1 acontecimiento
            expect(acs.num_acontecimientos).to eq 1

            # Repito evento mañana
            acs.repetir_evento(acontecimiento.creador, acontecimiento.hora_inicio, 2, DateTime.new(2020, 02, 11))

            # Hay 1 acontecimiento más
            expect(acs.num_acontecimientos).to eq 2

            # Ese será un día después al otro
            expect(acs.get(1).hora_inicio).to eq DateTime.new(2020, 02, 10, 12, 45)
        end

        it 'Se repite el evento mensualmente' do
            acs = Acontecimientos.new
            acs.aniadir_acontecimiento(acontecimiento)

            # Hay 1 acontecimiento
            expect(acs.num_acontecimientos).to eq 1

            # Repito evento mañana
            acs.repetir_evento(acontecimiento.creador, acontecimiento.hora_inicio, 3, DateTime.new(2020, 03, 03))

            # Hay 1 acontecimiento más
            expect(acs.num_acontecimientos).to eq 2

            # Ese será un día después al otro
            expect(acs.get(1).hora_inicio).to eq DateTime.new(2020, 03, 03, 12, 45)
        end
    end   
end