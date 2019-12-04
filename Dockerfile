# Se ha optado por una imagen base con Python 3.8
FROM python:3.8.0-slim-buster

# Establezco el creador del archivo
MAINTAINER albertosml@correo.ugr.es

# Actualizar el sistema, puesto que la imagen de Python se basa en la de Ubuntu 
RUN apt-get update

# Se crea un directorio base para ejecutar la aplicación
ENV DIR /home/ubuntu/app/
WORKDIR $DIR

# Habilito el puerto en una variable de entorno y lo expongo, para que puedan entrar peticiones desde ahí
EXPOSE $PORT

# Copiar solo aquellos archivos necesarios
COPY requirements.txt tasks.py $DIR
COPY src/*.py $DIR/src/

# Se instalan los paquetes necesarios para la ejecución de la aplicación
RUN pip3 install -r requirements.txt --no-cache-dir

# Se crea un usuario en el sistema para ejecutar el programa
RUN useradd -r ubuntu
USER ubuntu

# Ejecuto la tarea que lanza el servidor con gunicorn
CMD invoke run-server --port=$PORT