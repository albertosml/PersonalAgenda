require 'rspec'
require 'date'
require_relative '../src/acontecimiento'

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
            expect { Acontecimiento.new(titulo:'Reunión TFG', horainicio: DateTime.new(2017, 02, 03, 12, 45), creador: '@albertosml') }.to raise_error(Acontecimiento::AcontecimientoError, "No se pueden crear acontecimientos con una fecha pasada")
        end

        it 'La hora de inicio debe ser anterior a la hora de fin' do
            expect { Acontecimiento.new(titulo: 'Reunión TFG', horainicio: DateTime.new(2020, 03, 03, 12, 45), horafin: DateTime.new(2019, 03, 03, 10, 45), creador: '@albertosml') }.to raise_error(Acontecimiento::AcontecimientoError, "La hora de fin debe ser posterior a la hora de inicio")
        end

        it 'La hora de recuerdo debe ser anterior a la hora de inicio' do
            expect { Acontecimiento.new(titulo: 'Reunión TFG', horainicio: DateTime.new(2020, 03, 03, 12, 45), creador: '@albertosml', horarecuerdo: DateTime.new(2020, 03, 03, 15, 45)) }.to raise_error(Acontecimiento::AcontecimientoError, "La fecha de recuerdo debe ser anterior a la hora de inicio")
        end
    end
end