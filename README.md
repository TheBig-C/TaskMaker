# TaskMaker

Descripcion
Aplicación desarrollada en flutter que permite a los usuarios agregar nuevas tareas, marcarlas como completadas, eliminarlas de la lista, generar reportes por estado de tareas en curso y tareas completadas,

![Flutter]([https://github.com/tu-usuario/tu-repositorio/raw/main/carpeta-de-imagenes/logo.png](https://meterpreter.org/wp-content/uploads/2018/09/flutter.png))

Planificacion:
Como equipo planeamos desarrollar el programa en el trascurso de la semana, desde la fecha 08/03/2024 hasta 15/03/2024. Los integrantes del quipo son:

08/03/2024: definición de actividades correspondientes a cada miembro del equipo.
11/03/2024: primera presentacion para el desarrollo
12/03/2024: segunda presentacion para el desarrollo
13/03/2024: tercera presentacion para el desarrollo
14/03/2024: cuarta presentacion para el desarrollo
15/03/2024: ultima presentacion para el desarrollo y merge

Diseño:
Pantalla principal
Pantalla de ver/añadir tareas

Pages:
Task
Task UI HomePage
Task UI abm
Buscador
Calendario
Estadisticas

Ramas:
Main
Persistencia
Pages
Diseño

Funciones
Cesar Vera (Persistencia)
Christian Mendoza (Clases)
Ignacio Garcia (Diseño)

Configuración del Proyecto:

Para utilizar esta aplicación Flutter con una base de datos en Firebase, sigue los pasos a continuación:

Configurar Firebase

Accede a la consola de Firebase (https://console.firebase.google.com/) y crea un nuevo proyecto.
Configura tu proyecto para utilizar Firestore como base de datos.
Configurar Dependencias

En el archivo pubspec.yaml de tu proyecto Flutter, agrega las dependencias necesarias para Firebase. Ejemplo:

dependencies:
  firebase_core: ^2.5.0
  cloud_firestore: ^3.2.0
Inicializar Firebase

En el archivo principal de tu aplicación (generalmente main.dart), inicializa Firebase al inicio de tu aplicación:


import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
Acceder a la Base de Datos

Utiliza el servicio FirebaseFirestore para acceder y manipular datos en Firestore.

Ejecutar la Aplicación

Ejecuta tu aplicación Flutter usando el siguiente comando en la terminal:

flutter run
¡Listo! Ahora puedes disfrutar de tu aplicación Flutter conectada a una base de datos en Firebase. Asegúrate de ajustar las configuraciones y nombres de las colecciones según las necesidades específicas de tu proyecto.
