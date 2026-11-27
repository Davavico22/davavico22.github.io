# Ejemplo de splash screen en Flutter

Parte de un proyecto Flutter con Android e iOS, como el que genera `flutter create --platforms=android,ios notas_personales`.

1. Copia [flutter_native_splash.yaml](flutter_native_splash.yaml) junto a `pubspec.yaml`.
2. Guarda [splash.png](assets/splash.png) y [splash_android12.png](assets/splash_android12.png) en la carpeta `assets/` del proyecto.
3. Si estás usando un proyecto de prueba, sustituye `lib/main.dart` por el [main.dart del ejemplo](lib/main.dart).
4. Ejecuta estos comandos desde la raíz del proyecto.

```bash
flutter pub add --dev flutter_native_splash
dart run flutter_native_splash:create
flutter run
```

Una vez instalada la app, ciérrala por completo y ábrela desde su icono. Repite la prueba con el modo oscuro del sistema. Para ejecutar en iOS necesitas macOS con Xcode.

[Volver a la guía](../).
