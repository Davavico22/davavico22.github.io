# Ejemplo de temas claro y oscuro en Flutter

Parte de la plantilla del contador de Flutter con `MyApp` y `MyHomePage`.

1. Sustituye `lib/main.dart` de tu proyecto de prueba por el [main.dart del contador con temas](lib/main.dart).
2. En `pubspec.yaml`, conserva la dependencia `material_ui` de la plantilla y añade la que guarda el tema. Ejecuta estos comandos desde la raíz del proyecto.

```bash
flutter pub add shared_preferences
flutter run
```

Si tu proyecto todavía no tiene `material_ui`, añade los dos paquetes con `flutter pub add material_ui shared_preferences`. Flutter actualiza `pubspec.lock` al resolver las dependencias.

Pulsa **+** y abre el menú **Cambiar tema** en la barra superior. Prueba **Sistema**, **Claro** y **Oscuro**. Cierra la app después de cambiar el tema y vuelve a abrirla para comprobar la preferencia.

[Volver a la guía](../).
