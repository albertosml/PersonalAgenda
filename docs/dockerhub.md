# DockerHub

Primero, lo que se ha hecho es subir cada imagen de Docker creada a DockerHub, para ello, se ha hecho lo siguiente:

```
# Iniciar sesión en DockerHub
docker login --username=<username> --password

# Etiquetar la imagen
docker tag <image> <username>/<image>:<tag>

# Subo la imagen a DockerHub
docker push <username>/<image>
```

Luego, se va a la web de [DockerHub](https://hub.docker.com/) y, allí, en la imagen correspondiente, se va a habilitar
la construcción automática de la imagen en DockerHub, cada vez que se haga un push en la rama master, poniéndole a esta
la etiqueta latest; además, se ha configurado la ruta del Dockerfile, que use la caché para hacer la imagen, que haga
tests cada vez que se hace un pull request interno y que compruebe si la imagen base se ha actualizado, si es así, 
reconstruye la imagen.

![Construcción autómatica imagen DockerHub](images/construccion_automatica_dockerhub.png)

En ambos microservicios, se ha hecho lo mismo y, aquí, se presentan sus contenedores en DockerHub.

> Contenedor Acontecimiento: https://hub.docker.com/r/albertosml/acontecimiento

> Contenedor Dias No Laborables: https://hub.docker.com/r/albertosml/diasnolaborables