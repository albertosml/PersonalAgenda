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

### Apartados

- [Arquitectura y Tecnologías](arquitectura.md)

### Licencia

Finalmente, se ha optado por escoger una licencia GNU General Public License v3.0, la cual permite a la comunidad hacer 
lo que quiera con tu proyecto, excepto distribuir versiones cerradas del código ([Fuente](https://choosealicense.com/)). 

### Información adicional

También, se ha realizado una configuración del entorno para usar git y GitHub, el cual está disponible en el siguiente 
[enlace](configuracion_entorno.md).