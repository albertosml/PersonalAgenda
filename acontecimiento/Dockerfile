# Se ha optado por una imagen base con Ruby 2.6.5
FROM ruby:2.6.5-stretch

# Establezco el creador del archivo
MAINTAINER albertosml@correo.ugr.es

# Actualizar el sistema, puesto que la imagen de Ruby se basa en la de Ubuntu 
RUN apt-get update

# Se crea un directorio base para ejecutar la aplicación
ENV DIR /home/ubuntu/app/
WORKDIR $DIR

# Habilito el puerto en una variable de entorno y lo expongo, para que puedan entrar peticiones desde ahí 
EXPOSE $PORT

# Copiar solo aquellos archivos necesarios
COPY src $DIR/src/
COPY Gemfile Rakefile config.ru $DIR

# Se instalan los paquetes necesarios para la ejecución de la aplicación
RUN gem install rake
RUN rake build

# Se crea un usuario en el sistema para ejecutar el programa
RUN useradd -r ubuntu
USER ubuntu

# Ejecuto la tarea que lanza el servidor web
CMD rake run_server[$PORT]