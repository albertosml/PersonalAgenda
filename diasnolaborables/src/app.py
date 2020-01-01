from flask import Flask, request, jsonify
from diasnolaborables import DiasNoLaborables
from exceptions import DiasNoLaborablesException
from datetime import datetime
from flask_caching import Cache

config = {
    "CACHE_TYPE": "simple",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_IGNORE_ERRORS": True
}
app = Flask(__name__)
app.config.from_mapping(config)
cache = Cache(app)

# Función que transforma las fechas del conjunto
def transformar_conjunto(conjunto):
    for c in conjunto:
        if isinstance(c, str):
            c = datetime.strptime(c, '%d/%m/%Y')

    return conjunto


# Ruta para añadir un nuevo conjunto de días no laborables
@app.route('/diasnolaborables/nuevo', methods=['POST'])
def nuevo_conjunto_dias_no_laborables():
    data = request.get_json()
    usuario = data['usuario']
    dias_antelacion = data.get('diasantelacion', None)
    conjunto = data.get('conjunto', [])

    # Procesar conjunto de días no laborables
    conjunto = transformar_conjunto(conjunto)

    try:
        # Crear el conjunto de días no laborables para ese usuario
        DiasNoLaborables(usuario=usuario, dias_antelacion=dias_antelacion, conjunto=conjunto, insertar=True)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'Problemas al crear el conjunto' }), 200

    return jsonify({ 'msg': 'El conjunto de días laborables para ese usuario se ha creado' }), 200


# Ruta definida para añadir los días no laborables al conjunto
@app.route('/diasnolaborables/aniadir_dias', methods=['POST'])
def aniadir_dias_no_laborables():
    data = request.get_json()
    usuario = data['usuario']
    dias_a_aniadir = data['diasaaniadir']

    try:
        # Obtener el conjunto para ese usuario
        cd = DiasNoLaborables(usuario=usuario)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'No existe un conjunto de días no laborables para ese usuario' }), 200
    
    # Procesar conjunto de días no laborables
    dias_a_aniadir = transformar_conjunto(dias_a_aniadir)

    # Añadir los días no laborables al conjunto
    cd.aniadir_dias_no_laborables(dias_a_aniadir)

    return jsonify({ 'msg': 'Se han añadido los días no laborables correspondientes al conjunto' }), 200


# Ruta para eliminar un día no laborable del conjunto
@app.route('/diasnolaborables/eliminar_dia', methods=['POST'])
def eliminar_dia_no_laboral():
    data = request.get_json()
    usuario = data['usuario']
    dia_a_eliminar = data['diaaeliminar']

    try:
        # Obtener el conjunto para ese usuario
        cd = DiasNoLaborables(usuario=usuario)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'No existe un conjunto de días no laborables para ese usuario' }), 200
    
    # Transformar fecha (si se ha introducido)
    if isinstance(dia_a_eliminar, str):
        dia_a_eliminar = datetime.strptime(dia_a_eliminar, '%d/%m/%Y')

    # Se elimina el día no laboral del conjunto
    cd.eliminar_dia_no_laboral(dia_a_eliminar)

    return jsonify({ 'msg': 'Se ha eliminado el día del conjunto' }), 200


# Ruta para obtener los días no laborables entre 2 fechas
@app.route('/diasnolaborables/obtener_dias', methods=['POST'])
@cache.cached(timeout=60)
def obtener_dias():
    data = request.get_json()
    usuario = data['usuario']
    fecha_inicio = data['fechainicio']
    fecha_fin = data['fechafin']

    try:
        # Obtener el conjunto para ese usuario
        cd = DiasNoLaborables(usuario=usuario)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'No existe un conjunto de días no laborables para ese usuario' }), 200
    
    # Transformar fechas 
    fecha_inicio = datetime.strptime(fecha_inicio, '%d/%m/%Y')
    fecha_fin = datetime.strptime(fecha_fin, '%d/%m/%Y')

    # Devolver conjunto días no laborables
    dias_no_laborables = cd.devolver_dias_no_laborables_anio(fecha_inicio, fecha_fin)

    return jsonify({ 'diasnolaborables': dias_no_laborables }), 200


# Ruta para modificar los días de antelación de recuerdo de un día no laboral
@app.route('/diasnolaborables/modificar_recordatorio', methods=['POST'])
def modificar_recordatorio():
    data = request.get_json()
    usuario = data['usuario']
    dias_antelacion = data['diasantelacion']

    try:
        # Obtener el conjunto para ese usuario
        cd = DiasNoLaborables(usuario=usuario)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'No existe un conjunto de días no laborables para ese usuario' }), 200
    
    # Modificar días de antelación de recuerdo
    cd.modificar_dias_antelacion_recordatorio(dias_antelacion)

    return jsonify({ 'msg': 'Recordatorio modificado' }), 200


# Ruta para cancelar el recordatorio de un día no laboral
@app.route('/diasnolaborables/cancelar_recordatorio', methods=['POST'])
def cancelar_recordatorio():
    data = request.get_json()
    usuario = data['usuario']

    try:
        # Obtener el conjunto para ese usuario
        cd = DiasNoLaborables(usuario=usuario)
    except DiasNoLaborablesException:
        return jsonify({ 'msg': 'No existe un conjunto de días no laborables para ese usuario' }), 200
    
    # Cancelar recordatorio de un día no laboral de un usuario
    cd.cancelar_recordatorio()

    return jsonify({ 'msg': 'Recordatorio cancelado' }), 200