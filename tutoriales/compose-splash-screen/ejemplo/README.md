# Ejemplo de splash screen

Parte de un proyecto Empty Activity con Compose. Los archivos de esta carpeta se integran en ese proyecto.

- Copia [splash_themes.xml](res/values/splash_themes.xml) y [splash_colors.xml](res/values/splash_colors.xml) a `app/src/main/res/values/`, y el [color nocturno](res/values-night/splash_colors.xml) a `app/src/main/res/values-night/`.
- Adapta `Theme.Notas` al nombre de tu tema XML normal. Comprueba que existe `@mipmap/ic_launcher`.
- Añade `implementation("androidx.core:core-splashscreen:1.0.1")` a las dependencias del módulo. Si el proyecto ya usa esta biblioteca, conserva una versión compatible.
- Asigna `@style/Theme.Notas.Starting` a la actividad de entrada en el manifiesto.
- Usa [MainActivity.kt](MainActivity.kt) como referencia para incorporar `installSplashScreen()` antes de `super.onCreate()`. Adapta el paquete y conserva tu UI real.
