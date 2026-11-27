# Idiomas y traducciones en Flutter


> **Punto de partida.** Abre un proyecto Flutter que ya se ejecute en un emulador o dispositivo.

El [contador inicial de Flutter con un botón para cambiar de idioma](#ejemplo-completo-en-un-solo-archivo-dart) parte de la plantilla con `MyApp` y `MyHomePage`. Puedes copiar su `main.dart` directamente. El formulario de «Notas personales» que se explica a continuación es un ejemplo independiente para aprender a usar archivos ARB y guardar el idioma elegido.

## Activa la generación de traducciones

`material_ui` aporta los delegados que localizan los controles de Material. Los textos propios de la app van en archivos ARB. Flutter lee esos archivos y genera la clase Dart `AppLocalizations`, cuyo código generado usa `flutter_localizations` del SDK.

En `pubspec.yaml`, incorpora estas líneas en tus bloques `dependencies` y `flutter`. `intl: any` permite que el resolvedor use la versión compatible con `flutter_localizations`.

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

Añade Material y la dependencia que guardará el idioma elegido.

```bash
flutter pub add material_ui shared_preferences
```

## Escribe los mensajes en español e inglés

Copia [app_es.arb](ejemplo/lib/l10n/app_es.arb) y [app_en.arb](ejemplo/lib/l10n/app_en.arb) en `lib/l10n/`. Cada archivo conserva las mismas claves y traduce sus valores. Este fragmento de `app_es.arb` muestra una etiqueta, un saludo con nombre y un plural.

```json
{
  "signIn": "Entrar",
  "welcome": "Hola, {name}",
  "@welcome": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },
  "noteCount": "{count, plural, =0{Tienes 0 notas} one{Tienes 1 nota} other{Tienes {count} notas}}",
  "@noteCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

Los bloques `@welcome` y `@noteCount` declaran los parámetros en el archivo plantilla. En inglés, conserva los nombres `name` y `count` y traduce la frase completa.

```json
{
  "signIn": "Sign in",
  "welcome": "Hello, {name}",
  "noteCount": "{count, plural, =0{You have 0 notes} one{You have 1 note} other{You have {count} notes}}"
}
```

En el contador, `=0` selecciona el mensaje para cero, `one` cubre el singular y `other` proporciona el resto. Así cada idioma decide cómo expresar las cantidades.

## Genera y conecta AppLocalizations

Crea `l10n.yaml` junto a `pubspec.yaml`. La plantilla española define las claves y los tipos. `preferred-supported-locales` coloca el español primero en la lista generada y lo convierte en el idioma de respaldo si Flutter no encuentra una coincidencia compatible.

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
preferred-supported-locales: [es]
```

Genera el código desde la raíz del proyecto.

```bash
flutter gen-l10n
```

Desde `lib/main.dart`, importa `package:material_ui/material_ui.dart` y `l10n/app_localizations.dart`. En `MaterialApp`, combina el delegado generado para tus textos con los delegados de `material_ui`. [Configuración oficial de la localización con Material](https://docs.flutter.dev/ui/internationalization).

```dart
onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
localizationsDelegates: const [
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
],
supportedLocales: AppLocalizations.supportedLocales,
locale: _idioma.locale,
```

| Propiedad de `MaterialApp` | Para qué se usa |
| --- | --- |
| [`onGenerateTitle`](https://api.flutter.dev/flutter/material/MaterialApp/onGenerateTitle.html) | Devuelve el título de la aplicación. Recibe un `context` que ya tiene acceso a las traducciones, así que puede devolver «Notas personales» o «Personal notes». Para mostrar ese título dentro de la pantalla, asígnalo también a `AppBar.title`. |
| [`localizationsDelegates`](https://api.flutter.dev/flutter/material/MaterialApp/localizationsDelegates.html) | Indica qué componentes cargan los textos y formatos del idioma elegido. `AppLocalizations.delegate` carga las frases de tus ARB. `GlobalMaterialLocalizations.delegates`, importado desde `material_ui`, localiza los controles del framework, por ejemplo los textos de un selector de fechas. |
| [`supportedLocales`](https://api.flutter.dev/flutter/material/MaterialApp/supportedLocales.html) | Enumera los idiomas y variantes que entiende la app. Con la resolución predeterminada, una preferencia como `es-MX` puede coincidir con el español genérico `es`. Si Flutter no encuentra una coincidencia, usa el primer elemento de la lista. |
| [`locale`](https://api.flutter.dev/flutter/material/MaterialApp/locale.html) | Indica el idioma solicitado en ese momento. El selector pasa `Locale('es')` o `Locale('en')` para fijarlo y `null` para seguir las preferencias del dispositivo. Dentro de un widget, `Localizations.localeOf(context)` devuelve el idioma que Flutter resolvió. |

## Usa los textos en el formulario

Dentro de un widget descendiente de `MaterialApp`, obtén los textos con `AppLocalizations.of(context)!`. Una etiqueta genera un getter y los mensajes con parámetros generan métodos.

```dart
final textos = AppLocalizations.of(context)!;

Text(textos.signIn);
Text(textos.welcome('Ana'));
Text(textos.noteCount(2));
```

En el formulario, guarda el estado de la validación, por ejemplo `EstadoAcceso.correoInvalido`, y elige el texto en `build`. Si cambias de idioma con un aviso visible, Flutter vuelve a traducirlo a partir del mismo estado. Los nombres y el texto que escribe el usuario se conservan.

## Añade un selector y guarda el idioma

En el formulario con ARB, el selector ofrece **Idioma del sistema**, **Español** e **Inglés**. `MaterialApp.locale` recibe `null` para seguir el dispositivo, `Locale('es')` para español o `Locale('en')` para inglés. Cuando `MyApp` actualiza ese valor, las etiquetas del formulario y del selector se muestran en el idioma elegido.

```dart
enum IdiomaApp {
  sistema('system', null),
  espanol('es', Locale('es')),
  ingles('en', Locale('en'));

  const IdiomaApp(this.codigo, this.locale);

  final String codigo;
  final Locale? locale;
}
```

El ejemplo guarda una clave estable, como `es`, con `SharedPreferencesAsync`. Al iniciar, lee `idioma_app` antes de llamar a `runApp()`. Si la preferencia está vacía o no coincide con una opción, sigue el idioma del sistema. Este selector controla los textos de Flutter desde la app.

## Comprueba el resultado

| Prueba | Resultado esperado |
| --- | --- |
| Sistema en inglés con **Idioma del sistema**. | El formulario muestra «Email», «Password» y «Sign in». |
| Pulsa **Entrar** con el correo vacío y cambia a inglés. | El aviso cambia de «Revisa el correo.» a «Check your email.». |
| Elige **Español**, cierra la app y vuelve a abrirla. | Se conserva el español aunque el dispositivo esté en inglés. |
| Elige **Idioma del sistema** y cambia el dispositivo a otro idioma compatible. | Los textos siguen ese ajuste. Si no hay ningún idioma compatible entre las preferencias del dispositivo, se usa español. |
| Prueba `total: 0`, `total: 1` y `total: 2` en `AccesoTraducido`. | El contador muestra la frase de cero, singular o plural en el idioma seleccionado. |

Cada vez que edites un ARB, vuelve a ejecutar `flutter gen-l10n`. Si el IDE no encuentra `app_localizations.dart`, comprueba primero que `generate: true` esté dentro del bloque `flutter` y que el generador haya terminado correctamente.

## Ejemplo completo en un solo archivo Dart

El punto de partida es el contador de Flutter, con `MyApp`, `MyHomePage`, el tema morado y el botón flotante **+**. Al pulsar **Cambiar a inglés** o **Switch to Spanish**, cambian los textos de la interfaz. El contador conserva su valor porque su estado sigue en `_MyHomePageState`.

Copia el bloque completo en `lib/main.dart` o [abre el archivo Dart](ejemplo/sin-arb/main.dart). Si tu proyecto ya importa `material_ui`, puedes ejecutar directamente `flutter run`. Si te falta el paquete, añádelo desde la raíz del proyecto con `flutter pub add material_ui`. El ejemplo importa `GlobalMaterialLocalizations` desde `material_ui`. [Documentación de la migración de Material](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui#decoupled-localizations).

### Qué cambia respecto a la plantilla

| Cambio | Qué aporta y cuándo hace falta |
| --- | --- |
| `GlobalMaterialLocalizations.delegates` y `supportedLocales` | Permiten que Material use español o inglés. Las frases propias de la pantalla se eligen en Dart a partir del idioma activo. |
| `MyApp` pasa a ser un `StatefulWidget` y añade `_MyAppState` | El botón necesita actualizar `MaterialApp.locale` sin recrear toda la app. `_locale` empieza en `null` para seguir al dispositivo. Para una app que solo sigue el sistema, puedes conservar `MyApp` como `StatelessWidget` y prescindir de `_locale` y los botones de idioma. |
| `MyHomePage` mantiene su estado y recibe `onLocaleChanged` | La página comunica al widget raíz el idioma elegido. El título del `AppBar` se obtiene en `build` a partir del idioma activo, así que el parámetro fijo `title` de la plantilla deja de hacer falta. |
| `_enEspanol(context)` | Reutiliza la lectura de `Localizations.localeOf(context)` para el título de la aplicación y los textos de la pantalla. Es un atajo para evitar repetir la consulta. |
| `onGenerateTitle` | Es opcional. Traduce el título de la aplicación. La traducción de la barra se aplica mediante su propio `AppBar.title`. |
| Botones de idioma | El primero alterna entre español e inglés. El segundo es opcional y envía `null` para volver al idioma del dispositivo. |

En este contador bastan `Locale('es')`, `Locale('en')` y `null`. Un `enum` resulta útil si quieres agrupar las opciones del selector y sus claves de almacenamiento, como en el formulario con ARB. `shared_preferences` también es opcional. El contador de esta sección aplica el cambio durante la sesión y vuelve al idioma del sistema al reiniciar. El formulario con ARB muestra cómo conservar la elección.

```dart
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyApp());
}

bool _enEspanol(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'es';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void _cambiarIdioma(Locale? locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          _enEspanol(context) ? 'Demo de Flutter' : 'Flutter Demo',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es'), Locale('en')],
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(onLocaleChanged: _cambiarIdioma),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.onLocaleChanged});

  final ValueChanged<Locale?> onLocaleChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    final espanol = _enEspanol(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          espanol ? 'Inicio de la demo de Flutter' : 'Flutter Demo Home Page',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              espanol
                  ? 'Has pulsado el botón este número de veces:'
                  : 'You have pushed the button this many times:',
              textAlign: TextAlign.center,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final siguiente = espanol
                    ? const Locale('en')
                    : const Locale('es');
                widget.onLocaleChanged(siguiente);
              },
              child: Text(espanol ? 'Cambiar a inglés' : 'Switch to Spanish'),
            ),
            TextButton(
              onPressed: () => widget.onLocaleChanged(null),
              child: Text(espanol ? 'Idioma del sistema' : 'System language'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: espanol ? 'Incrementar' : 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Cambia el idioma de la app desde Ajustes de Android

Desde **Android 13 (API 33)**, el usuario puede abrir **Ajustes → Aplicaciones → Tu app → Idioma** y elegir un idioma solo para esa aplicación. Por ejemplo, puede usar el contador en inglés con el resto del teléfono en español. Android guarda esa preferencia por aplicación. Los textos en español e inglés ya deben estar definidos en Dart o en los archivos ARB. [Preferencias de idioma por aplicación en Android](https://developer.android.com/guide/topics/resources/app-languages#system-settings-for-users).

### Declara los idiomas que debe mostrar Android

En el proyecto Flutter, crea `android/app/src/main/res/xml/locale_config.xml`. Si la carpeta `xml` todavía no existe, créala dentro de `res`. Incluye los mismos idiomas que admite el ejemplo en `supportedLocales`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<locale-config xmlns:android="http://schemas.android.com/apk/res/android">
    <locale android:name="es" />
    <locale android:name="en" />
</locale-config>
```

En `android/app/src/main/AndroidManifest.xml`, añade este atributo a la etiqueta de apertura de `<application>`, junto a los atributos existentes.

```xml
android:localeConfig="@xml/locale_config"
```

El manifiesto señala el archivo y Android lo usa para saber qué opciones ofrecer en **Idioma**. Compila con `compileSdk` 33 o superior. El menú aparece en dispositivos con Android 13 o posterior. Si ya tienes `generateLocaleConfig = true` en el módulo Android, desactiva esa generación para usar el XML manual. La generación de Gradle obtiene los idiomas de los recursos nativos en `res/`. El archivo manual permite declarar explícitamente los que traduce tu código Dart o ARB. [Configuración manual de `android:localeConfig`](https://developer.android.com/guide/topics/resources/app-languages#use-localeconfig).

### Deja que Flutter lea el idioma elegido

Con `MaterialApp.locale` en `null`, Flutter sigue el idioma que Android entrega a la app. Android entrega la preferencia de esa aplicación cuando existe y, si el usuario elige el valor predeterminado, vuelve a usar el idioma general del dispositivo. Flutter elige una coincidencia de su lista `supportedLocales` y los widgets consultan ese idioma con `Localizations.localeOf(context)`. [Resolución del idioma en MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp/locale.html).

| Opción | Qué ocurre en el contador |
| --- | --- |
| Pulsas **Idioma del sistema** dentro del ejemplo. | El botón deja `_locale` en `null`. El contador usa el idioma por aplicación de Android si has elegido uno en Ajustes. |
| Pulsas **Cambiar a inglés** o **Switch to Spanish** dentro del ejemplo. | El botón fija un `Locale` en Flutter durante la sesión. Esa elección tiene prioridad en la interfaz del contador y el valor guardado por Android queda tal como estaba. |
| Quieres que el idioma solo se cambie desde Ajustes. | Omite `locale` en `MaterialApp` y conserva `supportedLocales` y `localizationsDelegates`. Puedes quitar los botones de idioma y el estado que los controla. |

### Comprueba el cambio en Android

1. Recompila e instala con `flutter run` para incorporar el XML y el manifiesto al APK.
2. Pon el teléfono en español. En **Ajustes → Aplicaciones → Tu app → Idioma**, selecciona inglés.
3. Abre el contador y comprueba que muestra **Flutter Demo Home Page** mientras el teléfono sigue en español. Si has fijado un idioma con el botón interno, pulsa **Idioma del sistema** en el contador para ceder el control a Android.
4. Vuelve a Ajustes y selecciona el idioma predeterminado del sistema para la app. El contador debe volver a mostrar **Inicio de la demo de Flutter**.

En Android 12 y anteriores puedes usar los botones internos del ejemplo para cambiar los textos de Flutter. [Selector de idioma y compatibilidad en Android](https://developer.android.com/guide/topics/resources/app-languages#handle-in-app-language-pickers).

## Archivos y referencias

- [Instrucciones y archivos del ejemplo](ejemplo/README.md).
- [Internacionalización en Flutter](https://docs.flutter.dev/ui/internationalization).
- [Selección de idioma en MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp/locale.html).
- [Temas claro y oscuro en Flutter](../flutter-temas/).
