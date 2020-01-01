import pymongo
import os

class DiasNoLaborablesStorage:
    def __init__(self, host='localhost', port=27017, database='diasnolaborables', collection='conjunto'):
        if 'DIASNOLABORABLES_DB_URL' in os.environ:
            host = os.environ['DIASNOLABORABLES_DB_URL']

        self.instance = pymongo.MongoClient(host, port)
        self.database = database
        self.collection = collection

    def _get_collection(self):
        return self.instance[self.database][self.collection]

    def insertar(self, data):
        self._get_collection().insert_one(data)

    def get_usuario(self, usuario):
        return self._get_collection().find_one({ 'usuario': usuario }, { '_id': 0, 'usuario': 0 })

    def guardar(self, usuario, data):
        self._get_collection().update_one({ 'usuario': usuario }, { '$set': data })