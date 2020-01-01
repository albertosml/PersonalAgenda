# Despliegue en un PaaS

Para hacer esto, se ha optado por usar [Heroku](https://www.heroku.com/), un PaaS gratuito, fácil de usar, el cual 
proporciona una capa de seguridad, al usar el protocolo HTTPS para la transmisión de información. Este PaaS ofrece varias
opciones de despliegue, eligiendo en este caso la opción de despliegue con Docker, aprovechando la creación de un 
Dockerfile para crear contenedores, el cual se hace de la siguiente manera:

```
# Iniciar sesión en Heroku a través del cliente
heroku login

# Iniciar sesión en el registro de contenedores de Heroku (con Heroku CLI)
heroku container:login

# Iniciar sesión en el registro de contenedores de Heroku
docker login --username=<username> --password=$(heroku auth:token) registry.heroku.com

# Subo la imagen Docker generada a la aplicación
heroku container:push web -a <app>

# Despliego los cambios en la aplicación
heroku container:release web -a <app>
```