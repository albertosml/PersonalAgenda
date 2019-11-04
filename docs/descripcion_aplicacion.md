# Descripción de la aplicación

**PersonalWorkerAgenda** es una aplicación, que se va a desplegar en la nube, la cual consiste en una agenda personal de 
trabajo en la cual se van a poder incluir acontecimientos laborables (tareas a hacer, citas, eventos, reuniones, 
recordatorios, etc...); también, se van a poder gestionar los días no laborables (fines de semana, festivos o 
vacaciones), para así no poder incluir acontecimientos laborables durante estos días.

Una vez introducida la aplicación, se van a exponer las entidades que componen el sistema, las cuales son:

1\) Acontecimiento

Una agenda va a estar formada por una lista de acontecimientos, que solo pueden ser individuales, los cuales estarán 
compuestos por un título, una descripción, una fecha de inicio, una fecha de fin, la persona asociada al acontecimiento
y la fecha de recuerdo. Entre sus funcionalidades, destacamos las siguientes:

- Crear un acontecimiento.
- Eliminar un acontecimiento ya incluido.
- Actualizar los datos del acontecimiento.
- Una persona no podrá tener dos acontecimientos a la misma hora, por lo que ninguno se podrá solapar.
- Devolver la agenda personal entre 2 fechas.
- Repetir un acontecimiento, indicando, la frecuencia con la que se repite y fecha de finalización de la repetición; 
si al repetir un acontecimiento en una fecha determinada, ya existe uno a esa hora para esa persona, esa copia del 
acontecimiento no se insertaría en esa hora.
- Restaurar un acontecimiento eliminado.
- Recordar un acontecimiento indicando para ello la fecha de recuerdo.
- Cancelar recordatorio.

2\) Dias no laborables 

Los días no laborables, como fines de semanas, festivos o vacaciones, son días en los cuales no se van a crear 
acontecimientos personales, por lo que antes de insertar un acontecimiento o modificar su fecha se comprobará que ese 
día sea laborable. Ese conjunto de días no laborables, estará formado por un motivo, fecha de recuerdo y el conjunto
de días no laborables (como pueden ser días de la semana concretos, un conjunto de días, que no tienen porque ser 
consecutivos, o un día concreto). Por tanto, las funcionalidades de esta entidad son las siguientes: 

- Crear un conjunto de días no laborables.
- Eliminar un conjunto de días no laborables ya existente.
- Modificar los datos de un conjunto de días no laborables.
- Añadir días a un conjunto de días no laborables.
- Eliminar días a un conjunto de días no laborables.
- Restaurar conjunto de días no laborables.
- Devolver los días no laborables de un año concreto.
- Recordar un conjunto de días no laborables indicando para ello la fecha de recuerdo.
- Cancelar recordatorio.
- Una persona no podrá tener un mismo día en 2 conjuntos de días no laborables.

Esta aplicación se ha creado para poder tener una agenda personal de trabajo online, sin necesidad de tener una agenda 
en papel o una libreta para ello, de cara a apuntar las tareas a hacer o las reuniones en el trabajo a los que hay que 
asistir; por lo que esta aplicación sería de gran utilidad para el futuro.