import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'src'))

import pytest
from app import app, s
import json

@pytest.fixture
def app_client():
    yield app.test_client()

def test_nuevo_dia_laboral(app_client):
    # Creo un nuevo conjunto de días no laborables
    response = app_client.post('/diasnolaborables/nuevo', data=json.dumps({ 'usuario': 'albertosml', 
                    'diasantelacion': 1, 'conjunto': [6]}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'El conjunto de días laborables para ese usuario se ha creado' }

    # Si vuelvo a crear el mismo conjunto la aplicación lanzará un error al ya existir un conjunto para ese usuario
    response = app_client.post('/diasnolaborables/nuevo', data=json.dumps({ 'usuario': 'albertosml', 
                    'diasantelacion': 1, 'conjunto': [6]}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'El usuario que quiere añadir ya está incluido' }

def test_aniadir_dias(app_client):
    # Añado el jueves al conjunto
    response = app_client.post('/diasnolaborables/aniadir_dias', data=json.dumps({ 'usuario': 'albertosml', 'diasaaniadir': [4]}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Se han añadido los días no laborables correspondientes al conjunto' }

def test_eliminar_dia(app_client):
    # Elimino el jueves del conjunto
    response = app_client.post('/diasnolaborables/eliminar_dia', data=json.dumps({ 'usuario': 'albertosml', 'diaaeliminar': 6}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Se ha eliminado el día del conjunto' }

def test_usuario_inexistente(app_client):
    # Intento eliminar un día del conjunto de un usuario inexistente
    response = app_client.post('/diasnolaborables/eliminar_dia', data=json.dumps({ 'usuario': '@JJ', 'diaaeliminar': 4}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'No existe un conjunto de días no laborables para ese usuario' }

def test_obtener_dias(app_client):
    # Intento eliminar un día del conjunto de un usuario inexistente
    response = app_client.post('/diasnolaborables/obtener_dias', data=json.dumps({ 'usuario': 'albertosml', 'fechainicio': '19/02/2020', 'fechafin': '01/03/2020'}), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'diasnolaborables': ['20/02/2020', '27/02/2020'] }

def test_modificar_recordatorio(app_client):
    # Modifico los días de antelación de recordatorio
    response = app_client.post('/diasnolaborables/modificar_recordatorio', data=json.dumps({ 'usuario': 'albertosml', 'diasantelacion': 5 }), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Recordatorio modificado' }

    # Chequear recordatorio
    cd = s.get_conjunto('albertosml')
    assert cd.dias_antelacion == 5

def test_cancelar_recordatorio(app_client):
    # Cancelo el recordatorio
    response = app_client.post('/diasnolaborables/cancelar_recordatorio', data=json.dumps({ 'usuario': 'albertosml' }), content_type='application/json')
    assert response.status_code == 200
    assert json.loads(response.get_data()) == { 'msg': 'Recordatorio cancelado' }

    # Chequear recordatorio
    cd = s.get_conjunto('albertosml')
    assert cd.dias_antelacion == None