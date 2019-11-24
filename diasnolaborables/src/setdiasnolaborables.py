from exceptions import DiasNoLaborablesException

class SetDiasNoLaborables:
    def __init__(self):
        self.conjuntos = []

    def existe_usuario(self, usuario):
        usuarios = [cjto.usuario for cjto in self.conjuntos]
        return usuario in usuarios

    def set_conjunto(self, conjunto):
        if self.existe_usuario(conjunto.usuario):
            raise DiasNoLaborablesException("Ya existe un conjunto de días no laborables de ese usuario")
        else:
            self.conjuntos.append(conjunto)

    def get_conjunto(self, usuario):
        for cjto in self.conjuntos:
            if cjto.usuario == usuario:
                return cjto

        raise DiasNoLaborablesException("No existe un conjunto de días no laborables para ese usuario")
