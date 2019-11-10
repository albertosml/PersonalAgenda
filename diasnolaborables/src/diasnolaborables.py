class DiasNoLaborablesException(Exception):
    """Excepciones asociadas a los días no laborables"""
    pass

class DiasNoLaborables:
    def __init__(self, usuario, dias_antelacion=None, conjunto=[]):
        # Comprobar usuario
        if self._existe_usuario(usuario):
            raise DiasNoLaborablesException("Usuario ya existente")
        self.usuario = usuario

        # Comprobar días de antelación
        if dias_antelacion and dias_antelacion < 0:
            self.dias_antelacion = dias_antelacion
        else:
            self.dias_antelacion = None
        
        # Comprobar conjunto
        if conjunto:
            self.conjunto = self._eliminar_dias_repetidos(conjunto)
        else:
            self.conjunto = conjunto

    def _existe_usuario(self, usuario):
        # Consulta a la base de datos
        return False

    def _eliminar_dias_repetidos(self, conjunto):
        # Divido el conjunto en días de semana y fechas
        dias_semana = set([x for x in conjunto if isinstance(x, int)])
        fechas = [x for x in conjunto if x not in dias_semana]

        conjunto = list(set(dias_semana))

        for fecha in fechas:
            if (fecha.weekday() + 1) not in dias_semana:
                conjunto.append(fecha)
        
        return conjunto