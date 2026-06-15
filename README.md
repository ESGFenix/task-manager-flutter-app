# Task Manager Flutter App

Aplicación móvil desarrollada con Flutter como proyecto de aprendizaje. La app funciona como un gestor de tareas donde el usuario puede crear, visualizar, editar, completar y eliminar tareas organizadas por categorías.

## Descripción

Este proyecto permite gestionar tareas personales de forma sencilla. Cada tarea puede tener:

* Nombre
* Descripción
* Fecha límite
* Categoría
* Estado: pendiente, completada o atrasada

La aplicación incluye una pantalla inicial de bienvenida y una pantalla principal donde las tareas se agrupan por categorías mediante un sistema de acordeones.

## Tecnologías utilizadas

* Flutter
* Dart
* Material Design
* Provider
* Shared Preferences
* JSON Serialization
* url_launcher
* accordion

## Funcionalidades principales

* Visualización de tareas por categorías.
* Creación de nuevas categorías.
* Edición de tareas existentes.
* Eliminación de tareas.
* Cambio de estado de una tarea a completada.
* Persistencia local de datos con Shared Preferences.
* Serialización y deserialización de datos en formato JSON.
* Interfaz personalizada con tema propio, fuente Poppins e imágenes locales.

## Arquitectura del proyecto

```text
lib/
├── main.dart
└── app/
    ├── app.dart
    ├── model/
    │   ├── task.dart
    │   └── task_category.dart
    ├── repository/
    │   └── task_repository.dart
    └── view/
        ├── components/
        ├── splash/
        └── task_list/
```

## Modelos de datos

### Task

Representa una tarea dentro de la aplicación.

Campos principales:

* `title`
* `description`
* `done`
* `taskState`
* `categoryId`
* `dueDate`

Estados posibles:

* `PENDING`
* `DONE`
* `LATE`

### TaskCategory

Representa una categoría de tareas.

Campos principales:

* `id`
* `name`

## Persistencia de datos

La aplicación guarda las tareas y categorías localmente usando `SharedPreferences`.

Los datos se convierten a JSON antes de guardarse y se reconstruyen al iniciar la aplicación. Para ello se utilizan las librerías `json_annotation`, `json_serializable` y `build_runner`.

## Gestión de estado

La gestión de estado se realiza con `Provider` y `ChangeNotifier`.

La clase `TaskProvider` se encarga de:

* Cargar tareas y categorías.
* Añadir nuevas tareas.
* Añadir nuevas categorías.
* Actualizar tareas.
* Eliminar tareas.
* Cambiar el estado de una tarea.
* Notificar los cambios a la interfaz.

## Interfaz de usuario

La app utiliza componentes personalizados y una estética sencilla basada en:

* Flutter Material Design.
* Fuente Poppins.
* Color principal turquesa.
* Imágenes locales en `assets/images/`.
* Acordeones para agrupar tareas por categoría.
* Tarjetas para mostrar cada tarea.
* Indicadores visuales para mostrar el estado de cada tarea.

## Dependencias principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.5.5
  json_annotation: ^4.11.0
  url_launcher: ^6.3.2
  provider: ^6.1.5+1
  accordion: ^2.6.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  json_serializable: ^6.13.1
  build_runner: ^2.4.0
```

## Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/ESGFenix/task-manager-flutter-app.git
```

### 2. Acceder al proyecto

```bash
cd task-manager-flutter-app
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Generar los archivos de serialización JSON

```bash
dart run build_runner build
```

### 5. Ejecutar la aplicación

```bash
flutter run
```

## Objetivos de aprendizaje

Este proyecto fue desarrollado con el objetivo de practicar conceptos fundamentales del desarrollo móvil con Flutter:

* Creación de interfaces mediante widgets.
* Navegación entre pantallas.
* Gestión de estado con Provider.
* Persistencia local de datos.
* Arquitectura basada en modelos y repositorios.
* Serialización y deserialización de objetos JSON.
* Organización y estructuración de proyectos Flutter.

## Autor

**Adrián Martínez Melero**

* GitHub: https://github.com/ESGFenix
* LinkedIn: https://www.linkedin.com/in/adrian-m-m
