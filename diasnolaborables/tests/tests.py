from pytest import raises
from datetime import datetime
from unittest.mock import patch

import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

from diasnolaborables import DiasNoLaborables
from exceptions import DiasNoLaborablesException

import mongomock


@mongomock.patch(servers=(('localhost', 27017),))
def test_creacion_dias_no_laborales():
    # Creación de un conjunto de días laborables sin días
    cd = DiasNoLaborables(usuario='@JJ', insertar=True)

    assert cd.usuario == '@JJ'
    assert cd.dias_antelacion == None
    assert cd.conjunto == []

    # Comprobar que los datos se han insertado en la base de datos
    data = cd.storage.get_usuario('@JJ')
    assert data['diasantelacion'] == None
    assert data['conjunto'] == []

    # No se puede insertar ese día no laborable ya que ahí existe un acontecimiento
    with patch.object(DiasNoLaborables, '_obtener_dias_con_acontecimiento', return_value=[datetime(2020, 2, 3)]):
        cd = DiasNoLaborables(usuario='@albertosml', dias_antelacion=2, conjunto=[datetime(2020, 1, 2), 
                                            datetime(2020, 2, 3)], insertar=True)
        assert cd.conjunto == [datetime(2020, 1, 2)]

    # Al especificar un día en el sexto día de la semana (sábado) el día de la semana no se guarda
    cd = DiasNoLaborables(usuario='@a', dias_antelacion=2, conjunto=[6, datetime(2019, 11, 9)], insertar=True)
    
    assert cd.conjunto == [6]

    # Creación de un conjunto de días laborables con días
    cd = DiasNoLaborables(usuario='@pepe', dias_antelacion=2, conjunto=[6, datetime(2020, 1, 2)], insertar=True)
    
    assert cd.conjunto == [6, datetime(2020, 1, 2)]


def crear_conjunto_dias_no_laborables():
    cd = DiasNoLaborables(usuario='@albertosml', conjunto=[6, datetime(2020, 1, 2)], insertar=True)
    return cd


@mongomock.patch(servers=(('localhost', 27017),))
def test_aniadir_dias_conjunto_dias_no_laborables():
    cd = crear_conjunto_dias_no_laborables()

    # No se pueden insertar días repetidos al conjunto
    cd.aniadir_dias_no_laborables(datetime(2020, 1, 2))

    assert cd.conjunto == [6, datetime(2020, 1, 2)]

    # Los días de la semana engloban a los días en sí
    cd.aniadir_dias_no_laborables([4])

    assert cd.conjunto == [4, 6]

    # Se insertan los nuevos días no laborales al no caer ni en jueves ni en sábado
    cd.aniadir_dias_no_laborables([datetime(2019, 12, 30), datetime(2019, 12, 31)])

    assert cd.conjunto == [4, 6, datetime(2019, 12, 30), datetime(2019, 12, 31)]


@mongomock.patch(servers=(('localhost', 27017),))
def test_eliminar_dias_conjunto_dias_no_laborables():
    cd = crear_conjunto_dias_no_laborables()

    # Eliminar del conjunto un día no laboral/día semana insertado
    cd.eliminar_dia_no_laboral(datetime(2020, 1, 2))

    assert cd.conjunto == [6]

    # Eliminar del conjunto día no laboral/día semana no insertado
    with raises(DiasNoLaborablesException, match="Este día no está insertado en el conjunto"):
        assert cd.eliminar_dia_no_laboral(1)


@mongomock.patch(servers=(('localhost', 27017),))
def test_devolver_dias_no_laborables_anio():
    cd = crear_conjunto_dias_no_laborables()

    # Devolver conjunto días no laborables (Enero 2020)
    dias_no_laborables = cd.devolver_dias_no_laborables_anio(datetime(2020, 1, 1), datetime(2020, 1, 31))

    assert dias_no_laborables == ['02/01/2020', '04/01/2020', '11/01/2020', '18/01/2020', '25/01/2020']


@mongomock.patch(servers=(('localhost', 27017),))
def test_modificar_recordatorio():
    cd = crear_conjunto_dias_no_laborables()

    assert cd.dias_antelacion == None

    cd.modificar_dias_antelacion_recordatorio(2)

    assert cd.dias_antelacion == 2

@mongomock.patch(servers=(('localhost', 27017),))
def test_cancelar_recordatorio():
    cd = DiasNoLaborables(usuario='@albertosml', dias_antelacion=2, insertar=True)

    assert cd.dias_antelacion == 2

    cd.cancelar_recordatorio()

    assert cd.dias_antelacion == None