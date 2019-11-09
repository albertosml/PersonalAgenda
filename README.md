# PersonalWorkerAgenda

[![Build Status](https://travis-ci.org/albertosml/PersonalWorkerAgenda.svg?branch=master)](https://travis-ci.org/albertosml/PersonalWorkerAgenda)  

## Apartados anteriores

- [Descripción de la aplicación](docs/descripcion_aplicacion.md)
- [Licencia](docs/licencia.md)
- [Información adicional](docs/informacion_adicional.md)
- [Arquitectura y tecnologías](docs/arquitectura_tecnologias.md)

## Integración continua y herramientas de construcción

### Entidad "Acontecimiento"

Para esta entidad, primero se ha configurado la integración continua con Travis a través del archivo `.travis.yml`:

```
language: ruby

rvm:
 - 2.6.5
 - 2.7
             
before_install:
 - cd acontecimiento
 - gem install bundle -v 2.0.2
 - bundle install
             
script:
 - cd acontecimiento
 - rake test --trace=stdout
```

En este archivo, se puede observar que para esta entidad se va a usar el lenguaje de programación Ruby, en concreto, se
van a usar las versiones 2.6.5 (la última versión estable) y la versión 2.7 (que es ahora mismo la versión de 
desarrollo) para ejecutar los tests.

Luego, antes de la ejecución de los tests, se va a proceder a la instalación de las herramientas necesarias para la 
ejecución, pues bien, para empezar, se va a instalar `bundle`, una herramienta que nos va a permitir instalar el resto 
de gemas especificadas en el archivo `Gemfile`, pero antes, hay que dirigirse al directorio `acontecimiento`, en el 
cual se ubica el código asociado a esta entidad y este archivo que se necesita, por último, se procede a instalar el 
resto de paquetes con el comando `bundle install`.

Finalmente, nos dirigimos al directorio, donde se ubica el código del microservicio, el cual contiene el archivo 
`Rakefile` con la tarea encargada de ejecutar los tests, con el comando `rake test --trace=stdout`; en este comando, se
ha especificado la opción `--trace=stdout` para imprimir el resultado de la ejecución de los tests en la salida estándar.

Lo siguiente que se ha hecho es configurar la herramienta de construcción, en el archivo `Rakefile`, en la cual se ha
agregado una tarea, llamada `test`, que se encarga de ejecutar los tests del microservicio con Rspec.

```
require 'rspec/core/rake_task'

task :tests do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'tests/tests.rb'
  end
  Rake::Task["spec"].execute
end
```
