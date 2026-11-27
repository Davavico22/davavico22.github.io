# Ejemplo de idiomas y traducciones en Flutter

Estas instrucciones son para el formulario «Notas personales» con archivos ARB. Si partes de la plantilla de Flutter con `MyApp` y `MyHomePage`, puedes copiar directamente el [contador con cambio de idioma](sin-arb/main.dart).

1. Copia [l10n.yaml](l10n.yaml) junto a `pubspec.yaml`.
2. Copia [app_es.arb](lib/l10n/app_es.arb) y [app_en.arb](lib/l10n/app_en.arb) en `lib/l10n/`.
3. Sustituye `lib/main.dart` en tu proyecto de prueba por el [main.dart del formulario](lib/main.dart).
4. En `pubspec.yaml`, incorpora las líneas nuevas a los bloques existentes. Conserva el resto de tus dependencias y los ajustes de Flutter.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

Ejecuta estos comandos desde la raíz del proyecto.

```bash
flutter pub add material_ui shared_preferences
flutter gen-l10n
flutter run
```

Prueba el selector con el formulario vacío y con un aviso de validación visible. Para ver los plurales del contador, cambia `total: 2` a `0` o `1` en `lib/main.dart`.

La guía incluye también el [contador de Flutter con un botón para cambiar de idioma](sin-arb/main.dart), que solo requiere `material_ui` como dependencia directa adicional a Flutter. Puedes seguir los [pasos para copiarlo en otro proyecto](../#ejemplo-completo-en-un-solo-archivo-dart).

[Volver a la guía](../).
