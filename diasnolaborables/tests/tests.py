from pytest import raises
from datetime import datetime
from unittest.mock import MagicMock

import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

import diasnolaborables

def test_creacion_dias_no_laborales():
    # Creación de un conjunto de días laborables sin días
    cd = diasnolaborables.DiasNoLaborables(usuario='@JJ')

    assert cd.usuario == '@JJ'
    assert cd.dias_antelacion == None
    assert cd.conjunto == []
    
    # Creación de un conjunto de días laborables con días
    cd = diasnolaborables.DiasNoLaborables(usuario='@albertosml', dias_antelacion=2, conjunto=[6, datetime(2020, 1, 2)])
    
    assert cd.conjunto == [6, datetime(2020, 1, 2)]

    # Al especificar un día en el sexto día de la semana (sábado) el día de la semana no se guarda
    cd = diasnolaborables.DiasNoLaborables(usuario='@a', dias_antelacion=2, conjunto=[6, datetime(2019, 11, 9)])
    
    assert cd.conjunto == [6]