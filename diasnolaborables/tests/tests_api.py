import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

import pytest
from app import app
from diasnolaborables import DiasNoLaborables
import json
import mongomock
from datetime import datetime

@pytest.fixture
def app_client():
    yield app.test_client()


@mongomock.patch(servers=(('localhost', 27017),))
def test_nuevo_dia_laboral(app_client):
    # Creo un nuevo conjunto de días no laborables
    response = app_client.post('/diasnolaborables/nuevo', data=json.dumps({ 'usuario': 'albertosml', 
                    'diasantelacion': 1, 'conjunto': [6]}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'El conjunto de días laborables para ese usuario se ha creado' }


def crear_conjunto_dias_no_laborables():
    DiasNoLaborables(usuario='albertosml', conjunto=[6, datetime(2020, 1, 2)], insertar=True)


@mongomock.patch(servers=(('localhost', 27017),))
def test_aniadir_dias(app_client):
    crear_conjunto_dias_no_laborables()

    # Añado el jueves al conjunto
    response = app_client.post('/diasnolaborables/aniadir_dias', data=json.dumps({ 'usuario': 'albertosml', 'diasaaniadir': [4]}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Se han añadido los días no laborables correspondientes al conjunto' }

    # Comprobar conjunto 
    cd = DiasNoLaborables(usuario='albertosml')
    assert cd.conjunto == [4, 6]


@mongomock.patch(servers=(('localhost', 27017),))
def test_eliminar_dia(app_client):
    crear_conjunto_dias_no_laborables()

    # Elimino el jueves del conjunto
    response = app_client.post('/diasnolaborables/eliminar_dia', data=json.dumps({ 'usuario': 'albertosml', 'diaaeliminar': 6}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Se ha eliminado el día del conjunto' }

    # Comprobar conjunto 
    cd = DiasNoLaborables(usuario='albertosml')
    assert cd.conjunto == [datetime(2020, 1, 2)]    


@mongomock.patch(servers=(('localhost', 27017),))
def test_usuario_inexistente(app_client):
    # Intento eliminar un día del conjunto de un usuario inexistente
    response = app_client.post('/diasnolaborables/eliminar_dia', data=json.dumps({ 'usuario': '@JJ', 'diaaeliminar': 4}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'No existe un conjunto de días no laborables para ese usuario' }


@mongomock.patch(servers=(('localhost', 27017),))
def test_obtener_dias(app_client):
    crear_conjunto_dias_no_laborables()

    # Intento eliminar un día del conjunto de un usuario inexistente
    response = app_client.post('/diasnolaborables/obtener_dias', data=json.dumps({ 'usuario': 'albertosml', 'fechainicio': '19/02/2020', 'fechafin': '01/03/2020'}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'diasnolaborables': ['22/02/2020', '29/02/2020'] }


@mongomock.patch(servers=(('localhost', 27017),))
def test_modificar_recordatorio(app_client):
    crear_conjunto_dias_no_laborables()

    # Modifico los días de antelación de recordatorio
    response = app_client.post('/diasnolaborables/modificar_recordatorio', data=json.dumps({ 'usuario': 'albertosml', 'diasantelacion': 5 }), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Recordatorio modificado' }

    # Chequear recordatorio
    cd = DiasNoLaborables(usuario='albertosml')
    assert cd.dias_antelacion == 5


@mongomock.patch(servers=(('localhost', 27017),))
def test_cancelar_recordatorio(app_client):
    DiasNoLaborables(usuario='albertosml', conjunto=[6, datetime(2020, 1, 2)], dias_antelacion=5, insertar=True)

    # Cancelo el recordatorio
    response = app_client.post('/diasnolaborables/cancelar_recordatorio', data=json.dumps({ 'usuario': 'albertosml' }), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Recordatorio cancelado' }

    # Chequear recordatorio
    cd = DiasNoLaborables(usuario='albertosml')
    assert cd.dias_antelacion == None