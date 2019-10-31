# PersonalAgenda

### Descripción de la aplicación

**PersonalAgenda** es una aplicación, que se va a desplegar en la nube, la cual consiste en una agenda en la que se van
a poder incluir tareas a hacer, citas, eventos, reuniones o recordatorios, que pueden ser personales o grupales. 

Una vez introducida la aplicación, se van a exponer las entidades que componen el sistema, las cuales son:

1\) Ítem

Un ítem es un acontecimiento que se añade en la agenda personal, como puede ser una tarea a hacer, una cita, un evento 
o una reunión, el cual puede pertenecer a varias agendas; en consecuencia, aquí se puede deducir, que una agenda 
personal va a estar formada por una lista de ítems. Por lo tanto, este ítem estará compuesto por un título, una 
descripción, una fecha de inicio, la duración, la persona administradora de este y las personas asociadas al ítem (puede
no haber, en el caso de los acontecimientos individuales). Entre sus funcionalidades, destacamos las siguientes:

- Crear un ítem.
- Eliminar un ítem ya incluido.
- Actualizar los datos del ítem.
- Una persona no podrá tener dos acontecimientos a la misma hora, por lo que ninguno se podrá solapar.
- Devolver la agenda personal entre 2 fechas.
- Añadir una persona al ítem, comprobando que no tiene ningún ítem solapado con este ni esté ya agregado a él.
- Eliminar a una persona de un ítem ya creado.
- Cambiar organizador (administrador) del ítem, para ello el nuevo organizador tiene que ser un asistente al 
acontecimiento y, si es así sus posiciones se verían intercambiadas.
- Repetir un ítem, indicando, la frecuencia con la que se repite y fecha de finalización de la repetición; 
si al repetir el ítem en una fecha determinada, ya existe uno a esa hora para alguno de los asistentes, esta repetición 
del ítem no se insertaría para él.
- Restaurar un ítem eliminado.
- Solo el organizador del ítem podrá modificarlo, eliminarlo, restaurarlo o repetirlo, así como añadir o eliminar 
personas de este.

2\) Recordatorio

A un ítem se le podrán asociar recordatorios del acontecimiento, los cuales serán personales o grupales, siendo estos 
últimos solamente incluidos, modificados e eliminados por el administrador del ítem. Los recordatorios grupales estarán
formados por el ítem y, la frecuencia de recuerdo o el momento en el que se quiere recordar; los recordatorios 
personales, son recordatorios que aparte se componen de la persona asociada al recordatorio, puesto que el recordatorio
personal puede ser para un acontecimiento personal o grupal. Por tanto, la funcionalidad de esta entidad es la 
siguiente: 

- Crear un recordatorio personal.
- Crear un recordatorio grupal.
- Eliminar un recordatorio.
- Restaurar un recordatorio ya eliminado.
- Modificar la frecuencia de recuerdo de un recordatorio.
- Notificar recordatorio a todos los asistentes al ítem.
- Listar los recordatorios de una persona.

Esta aplicación se ha creado para poder tener una agenda personal online, sin necesidad de tener una agenda en papel o 
una libreta para ello, de cara a apuntar las tareas a hacer en la facultad, exámenes o presentaciones a los que hay que 
asistir o citas personales que se tengan; por lo que esta aplicación sería de gran utilidad para el futuro.

### Arquitectura

La arquitectura que se va a usar para esta aplicación es una basada en microservicios, en la cual cada entidad del 
problema será un microservicio, desplegando así de forma independiente la lógica de cada uno de los elementos 
principales del problema. 

Ahora, se va a exponer un diagrama que representa la arquitectura de la aplicación:

![Diagrama Arquitectura](docs/images/arquitectura_cc.png)

En él, se puede observar que va a haber un cliente, que en este caso, es un bot de Telegram, pero podría ser una web o 
una aplicación (aunque, en ese caso, se tendría que añadir un microservicio para la gestión de usuarios, ya que en esta
aplicación se pasa la autentación de los usuarios a Telegram); pues bien, este cliente, se va a comunicar con nuestro 
servidor a través de una API Gateway, a la cual le enviará peticiones. 

Esta API Gateway, se encargará de recibir las peticiones de cada cliente y pasárselas al microservicio más adecuado para
su procesamiento. Luego, cada microservicio monta una REST API, encargada de gestionar las peticiones para esa entidad 
y, una base de datos, en la que se almacena la información sobre la entidad de cada microservicio.

También, se dispondrá de un sistema de logs centralizado para almacenar el historial de peticiones del sistema, así 
como de un sistema de almacenamiento de la configuración crítica de la aplicación (direcciones y puertos de los 
microservicios, API keys, etc..), el cual va a estar centralizado. Tanto el API gateway como los microservicios, van a 
estar conectados a estos dos sistemas, de los cuales se acaban de hablar.

Respecto a la comunicación entre los microservicios, se va a usar el protocolo HTTP, para la transmisión de información 
sobre los ítems a los recordatorios.

Por último, se va a montar un broker de mensajería mediante el patrón `publish/subscribe` para las notificaciones de 
recordatorios, donde el recordatorio publica un mensaje con el contenido de la notificación, a la cola de mensajes del 
API gateway; luego, este API gateway consume el mensaje y envía la notificación correspondiente a esa persona. 

### Tecnologías

Ahora, se van a presentar las tecnologías (y bibliotecas), que van a usar los diferentes elementos de la aplicación:

- API Gateway -> Para este elemento, se ha optado por usar el lenguaje [Go](https://golang.org/), el cual es compilado y 
permite controlar de forma eficiente, sencilla y automática la concurrencia, pudiendo así procesar más rápidamente las 
peticiones de los clientes al sistema, al poder atender más peticiones a la vez de forma eficiente. En concreto, se va a 
usar el framework [KrakenD](https://github.com/devopsfaith/krakend), el cual permite montar una API Gateway que sea 
sencilla de configurar (para conectar los microservicios), concurrente y de alto rendimiento, también, este framework 
permite mantener un sistema de logs con el historial de peticiones del sistema.

- Entidad `Item` -> Para este microservicio, se va a optar por usar el lenguaje de programación 
[Ruby](https://www.ruby-lang.org/en/), que es un lenguaje interpretado; en concreto, se va a usar el lenguaje específico 
para crear aplicaciones web, llamado [Sinatra](https://github.com/sinatra/sinatra), el cual permite montar una REST API 
de manera muy sencilla, gestionando todo tipo de peticiones HTTP. La base de datos que va a usar este microservicio es 
[Apache Cassandra](http://cassandra.apache.org/), la cual es una base de datos no relacional orientada a columnas, 
eligiéndose debido a su escalibilidad, su tolerancia a fallos, su eficiente sistema de indexación y, garantizando además
que toda columna de un registro tiene su correspondiente valor, siendo este nuestro caso para esta entidad; pues bien,
para que esta base de datos se comunique con nuestro microservicio en Ruby, se va a usar la librería 
[cassandra-driver](https://github.com/datastax/ruby-driver). También, se va almacenar aquí la configuración crítica del 
sistema, usando un almacén clave-valor distribuido como es [etcd](https://github.com/etcd-io/etcd), el cual se puede 
usar en Ruby de manera sencilla, a través de la librería [etcdv3](https://github.com/davissp14/etcdv3-ruby). Por último,
para almacenar los logs de este microservicio, se va a usar la librería [logger](https://github.com/ruby/logger) y, para
testear el microservicio se usará un módulo de test de alto nivel llamado [rspec](https://github.com/rspec/rspec).

- Entidad `Recordatorio` -> Para este microservicio, se ha optado por usar el framework 
[Flask](http://flask.palletsprojects.com/en/1.1.x/), basado en un lenguaje de programación interpretado y, muy usado en 
la actualidad, como es [Python](https://www.python.org/). Este microservicio va a tener asociada una base de datos no 
relacional orientada a documentos, como es [MongoDB](https://www.mongodb.com/), elegida para esta entidad debido a su 
escabilidad, eficiencia y, sobre todo, por su flexibilidad en la estructura de datos, ya que va a haber recordartorios 
que no tengan personas asociadas, los cuales serían los grupales; la aplicación web se va a comunicar con la base de 
datos a través de la librería [pymongo](https://api.mongodb.com/python/current/). Para los logs del microservicio, se va 
a utilizar la librería [logging](https://docs.python.org/2/library/logging.html), la cual viene asociada ya de serie al 
lenguaje. Por último, para obtener la información de los ítems asociados a los recordatorios, este microservicio hará 
peticiones HTTP a la REST API creada para la entidad `Item`, usando la librería 
[requests](https://requests.kennethreitz.org/en/master/); para las notificaciones de los usuarios a las personas 
correspondientes, se montará un broker de mensajería con RabbitMQ, el cual usa el protocolo AMQP para las comunicaciones, 
usando para ello la librería [pika](https://pika.readthedocs.io/en/stable/); para realizar los tests unitarios, se usará
la librería [pytest](https://docs.pytest.org/en/latest/).

### Licencia

Finalmente, se ha optado por escoger una licencia GNU General Public License v3.0, la cual permite a la comunidad hacer 
lo que quiera con tu proyecto, excepto distribuir versiones cerradas del código ([Fuente](https://choosealicense.com/)). 

### Información adicional

También, se ha realizado una configuración del entorno para usar git y GitHub, el cual está disponible en el siguiente 
[enlace](docs/configuracion_entorno.md).

Esta aplicación es el proyecto del alumno Alberto Silvestre Montes Linares para la asignatura Cloud Computing del máster
en Ingeniería Información de la Universidad de Granada (UGR).