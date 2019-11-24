from datetime import datetime, timedelta
from exceptions import DiasNoLaborablesException

class DiasNoLaborables:
    def __init__(self, usuario, dias_antelacion=None, conjunto=[]):
        # Usuario
        self.usuario = usuario

        # Comprobar días de antelación
        if dias_antelacion and dias_antelacion > 0:
            self.dias_antelacion = dias_antelacion
        else:
            self.dias_antelacion = None
        
        # Comprobar conjunto
        self.conjunto = conjunto
        self._limpiar_conjunto()

    def _obtener_dias_semanas_conjunto(self):
        return set([x for x in self.conjunto if isinstance(x, int)])

    def _obtener_fechas_conjunto(self):
        return [x for x in self.conjunto if isinstance(x, datetime)]

    def _limpiar_conjunto(self):
        self._eliminar_dias_repetidos()
        self._eliminar_dias_con_acontecimiento() 

    def _obtener_dias_con_acontecimiento(self):
        # Consulta a la base de datos
        return []

    def _eliminar_dias_con_acontecimiento(self):
        for dia in self._obtener_dias_con_acontecimiento():
            self.conjunto.remove(dia)

    def _eliminar_dias_repetidos(self):
        # Divido el conjunto en días de semana y fechas
        dias_semana = self._obtener_dias_semanas_conjunto()
        fechas = self._obtener_fechas_conjunto()

        # Elimino fechas duplicadas
        fechas = list(dict.fromkeys(fechas))

        self.conjunto = list(set(dias_semana))

        for fecha in fechas:
            if (fecha.weekday() + 1) not in dias_semana:
                self.conjunto.append(fecha)

    def _es_dia_no_laboral(self, fecha):
        # Compruebo si la fecha pertenece a un día de la semana no laboral
        dias_semana = self._obtener_dias_semanas_conjunto()
        if (fecha.weekday() + 1) in dias_semana:
            return True

        # Compruebo si la fecha pertenece a un día no laboral
        fechas = self._obtener_fechas_conjunto()
        if fecha in fechas:
            return True

        return False

    def aniadir_dias_no_laborables(self, conjunto):
        if isinstance(conjunto, (int, datetime)):
            self.conjunto.append(conjunto)
        else:
            self.conjunto += conjunto

        self._limpiar_conjunto()

    def eliminar_dia_no_laboral(self, elem):
        try:
            self.conjunto.remove(elem)
        except Exception:
            raise DiasNoLaborablesException("Este día no está insertado en el conjunto")

    def devolver_dias_no_laborables_anio(self, fecha_inicio, fecha_fin):
        dias_no_laborables = []

        while fecha_inicio <= fecha_fin:
            if self._es_dia_no_laboral(fecha_inicio):
                dias_no_laborables.append(fecha_inicio.strftime("%d/%m/%Y"))

            fecha_inicio = fecha_inicio + timedelta(days=1)

        return dias_no_laborables

    def modificar_dias_antelacion_recordatorio(self, dias_antelacion):
        self.dias_antelacion = dias_antelacion

    def cancelar_recordatorio(self):
        self.modificar_dias_antelacion_recordatorio(None)