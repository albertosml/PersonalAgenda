# PersonalAgenda

### Descripción de la aplicación

**PersonalAgenda** es una aplicación, que se va a desplegar en la nube, la cual consiste en una agenda en la que se van
a poder incluir tareas a hacer, citas, eventos, reuniones o recordatorios, que pueden ser personales o grupales. 

Una vez introducida la aplicación, se van a exponer las entidades que componen el sistema, las cuales son:

1\) Ítem

Un ítem es un acontecimiento que se añade en la agenda personal, como puede ser una tarea a hacer, una cita, un evento 
o una reunión, el cual puede pertenecer a varias agendas; en consecuencia, aquí se puede deducir, que una agenda 
personal va a estar formada por una lista de ítems. Por lo tanto, este ítem estará compuesto por un título, una 
descripción, una fecha de inicio, la duración, la persona administradora de este y las personas asociadas al ítem (si 
las hay, esto no ocurre en acontecimientos individuales). Entre sus funcionalidades, destacamos las siguientes:

- Crear un ítem.
- Eliminar un ítem ya incluido.
- Actualizar los datos del ítem.
- Una persona no podrá tener dos acontecimientos a la misma hora, por lo que ninguno se podrá solapar.
- Devolver la agenda personal entre 2 fechas.
- Añadir una persona al ítem, comprobando que no tiene ningún ítem solapado con este ni esté ya agregado a él.
- Eliminar a una persona de un ítem ya creado.
- Si el creador o administrador del ítem se elimina a sí mismo, este deberá asignar a una persona administradora del ítem.
- Repetir un ítem, indicando, la frecuencia con la que se repite y fecha de finalización de la repetición; 
si al repetir el ítem en una fecha determinada, ya existe uno a esa hora para alguno de los asistentes, esta repetición 
del ítem no se insertaría para él.
- Solo el administrador del ítem podrá modificarlo, eliminarlo o repetirlo, así como añadir o eliminar personas de este.

2\) Recordatorio

A un ítem se le podrán asociar recordatorios del acontecimiento, los cuales serán personales o grupales, siendo estos 
últimos solamente incluidos, modificados e eliminados por el administrador del ítem. Los recordatorios grupales estarán
formados por el ítem y, la frecuencia de recuerdo o el momento en el que se quiere recordar; los recordatorios 
personales, son recordatorios que aparte se componen de la persona asociada al recordatorio, puesto que el recordatorio
personal puede ser para un acontecimiento personal o grupal. Por tanto, la funcionalidad de esta entidad es la 
siguiente: 

- Crear un recordatorio personal.
- Eliminar un recordatorio personal.
- Modificar los datos de un recordatorio personal.
- Crear un recordatorio grupal.
- Eliminar un recordatorio grupal.
- Modificar los datos de un recordatorio grupal.
- Notificar recordatorio a todos los asistentes al ítem.
- Listar los recordatorios de una persona.

Esta aplicación se ha creado para poder tener una agenda personal online, sin necesidad de tener una agenda en papel o 
una libreta para ello, de cara a apuntar las tareas a hacer en la facultad, exámenes o presentaciones a los que hay que 
asistir o citas personales que se tengan; por lo que esta aplicación sería de gran utilidad para el futuro.

### Arquitectura y Tecnologías

La arquitectura que se va a usar para esta aplicación es una basada en microservicios, en la cual cada 
entidad del problema será un microservicio, desplegando así de forma independiente la lógica de cada uno de los 
elementos principales del problema. 

Ahora, se va a exponer un diagrama que representa la arquitectura de la aplicación:

![Diagrama arquitectura](images/arquitectura_cc.png)

En él, se puede observar que va a haber un cliente, que en este caso, es un bot de Telegram, pero podría ser una web o 
una aplicación (aunque, en ese caso, se tendría que añadir un microservicio para la gestión de usuarios, ya que en esta
aplicación se pasa la autentación de los usuarios a Telegram); pues bien, este cliente, se va a comunicar con nuestro 
servidor a través de una API Gateway, a la cual le enviará peticiones. 

Esta API Gateway, se encargará de recibir las peticiones de cada cliente y pasárselas al microservicio más adecuado para
su procesamiento, por lo que aquí, se ha optado por usar el lenguaje de programación Go, el cual permite controlar de 
forma eficiente, sencilla y automática la concurrencia, para así poder procesar más rápidamente las peticiones de los 
clientes. También, dispondrá de un sistema de logs para almacenar el historial de peticiones del sistema.

Luego, el API Gateway, se encargará de enviar la petición al microservicio adecuado, los cuales montan una REST API, 
encargada de gestionar las peticiones para esa entidad y, un sistema de logs para almacenar los resultados de ejecución
de cada petición a esa entidad. Para la entidad `Item`, se ha optado por usar el lenguaje de programación Ruby, que es 
un lenguaje interpretado, con una base de datos Apache Cassandra, la cual es una base de datos no relacional basado en 
el modelo "clave-valor", eligiéndose debido a su eficiente sistema de indexación y, además garantiza que toda columna de 
un registro tiene su correspondiente valor, siendo este nuestro caso para esta entidad; también, se va almacenar aquí la
configuración del sistema. Para la entidad `Recordatorio`, se ha optado por usar el framework Flask, basado en Python, 
otro lenguaje interpretado, que permite fácilmente montar API, junto con una base de datos MongoDB, la cual es una base 
de datos no relacional orientada a documentos, elegida para esta entidad debido a su escabilidad, eficienta y, sobre 
todo, por su flexibilidad en la estructura de datos, ya que va a haber recordartorios que no tengan personas asociadas, 
los cuales serían los grupales.

Respecto a la comunicación entre los microservicios, se va a usar RabbitMQ, para montar un broker de mensajería, en la 
cual los recordatorios, van a acceder a los ítems, para obtener información sobre estos últimos, por lo que el flujo 
aquí, sería el siguiente:

    1) El recordatorio publica un mensaje a la cola de mensajes del ítem
    para obtener información sobre él.
    2) El ítem consume ese mensaje y publica un mensaje a la cola de
    mensajes del recordatorio para devolver la información solicitada.
    3) El recordatorio consume la respuesta a su mensaje.

Por último, se va a montar otro broker de mensajería con RabbitMQ, para que un recordatorio publique una notificación de
un recordatorio, en la cola de mensajes del cliente que vaya a consumir esa notificación.

### Licencia

Finalmente, se ha optado por escoger una licencia GNU General Public License v3.0, la cual permite a la comunidad hacer 
lo que quiera con tu proyecto, excepto distribuir versiones cerradas del código ([Fuente](https://choosealicense.com/)). 

### Información adicional

También, se ha realizado una configuración del entorno para usar git y GitHub, el cual está disponible en el siguiente 
[enlace](https://github.com/albertosml/PersonalAgenda/blob/master/docs/configuracion_entorno.md).

**Por último, indicar que esta aplicación es el proyecto del alumno Alberto Silvestre Montes Linares para la asignatura
Cloud Computing.**