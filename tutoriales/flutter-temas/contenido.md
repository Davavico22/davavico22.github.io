# Temas claro y oscuro en Flutter

Partimos del contador inicial de Flutter con `MyApp`, `MyHomePage` y el botón flotante **+**. Añadiremos un menú de apariencia en la barra superior para elegir **Sistema**, **Claro** u **Oscuro**. Al cambiar el tema se actualizan los colores de la interfaz y el contador conserva su valor.

> **Punto de partida.** Abre un proyecto Flutter que ya se ejecute en un emulador o dispositivo.

Puedes ir al [resumen de archivos](#archivos-que-debes-modificar) o al [`main.dart` completo](#main-dart-completo-para-copiar-y-pegar) si ya conoces `ThemeData`.

## Diseña con pares de color

En Flutter, `ThemeData` reúne los colores y los estilos de los componentes. Sus colores se definen en un `ColorScheme` y se organizan por funciones. Si personalizas el fondo de la barra superior, usa el rol correspondiente para el texto y los iconos que van encima.

| Par | Dónde usarlo |
| --- | --- |
| `primary` / `onPrimary` | Fondo y texto de una acción destacada. |
| `primaryContainer` / `onPrimaryContainer` | Fondo y contenido de un bloque destacado, como la barra superior del contador. |
| `surface` / `onSurface` | Superficies de la interfaz y contenido sobre ellas. |

## Crea dos esquemas de Material 3

`ColorScheme.fromSeed` genera los roles a partir de un color de marca. Conserva `Colors.deepPurple` de la plantilla y usa dos valores de `Brightness` para que cada esquema tenga sus propios fondos y colores de texto.

```dart
const colorSemilla = Colors.deepPurple;

final temaClaro = crearTema(Brightness.light);
final temaOscuro = crearTema(Brightness.dark);

ThemeData crearTema(Brightness brillo) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorSemilla,
      brightness: brillo,
    ),
  );
}
```

El color de semilla sirve para calcular la paleta. El valor de `primary` puede ser distinto en cada modo para adaptarse al fondo y conservar el contraste.

## Aplica el tema a toda la interfaz

En `MaterialApp`, `theme` proporciona el tema claro, `darkTheme` el oscuro y `themeMode` decide cuál aplicar. `ThemeMode.system` sigue la apariencia del dispositivo. `ThemeMode.light` y `ThemeMode.dark` fuerzan la elección del usuario. [Modos de tema en MaterialApp](https://pub.dev/documentation/material_ui/latest/material_ui/MaterialApp/themeMode.html).

```dart
return MaterialApp(
  title: 'Flutter Demo',
  theme: temaClaro,
  darkTheme: temaOscuro,
  themeMode: _modo,
  home: MyHomePage(
    title: 'Flutter Demo Home Page',
    modo: _modo,
    cambiarModo: _cambiarModo,
  ),
);
```

En el `build` de `MyHomePage`, consulta `Theme.of(context).colorScheme` para obtener los roles del esquema activo. Usa el `context` de un widget que esté dentro de `MaterialApp`, como el de esta pantalla.

```dart
final colores = Theme.of(context).colorScheme;
```

El ejemplo aplica `colores.primaryContainer` al fondo de `AppBar` y `colores.onPrimaryContainer` a su título e iconos. El botón flotante y el estilo del contador heredan el tema activo.

## Añade el menú de apariencia

| Cambio respecto a la plantilla | Qué aporta |
| --- | --- |
| `MyApp` pasa a ser un `StatefulWidget`. | `_MyAppState` guarda el modo actual y llama a `setState` para actualizar `MaterialApp.themeMode`. |
| `MyHomePage` conserva su estado y recibe `modo` y `cambiarModo`. | Puede mostrar qué modo está seleccionado y comunicar la elección a `MyApp`. El número sigue en `_MyHomePageState`, así que no se reinicia al cambiar de tema. |
| `PopupMenuButton<ThemeMode>` en `AppBar.actions`. | Abre las opciones **Sistema**, **Claro** y **Oscuro** desde el icono **Cambiar tema**. El propio Flutter ya define `ThemeMode`. |

Si solo quieres seguir la apariencia del dispositivo, conserva `MyApp` como `StatelessWidget`, define `theme` y `darkTheme` y usa `ThemeMode.system`. El menú y el estado que lo controla son necesarios para ofrecer el cambio manual.

## Guarda la elección al cerrar la app

Guardar la elección es opcional. El código completo usa `SharedPreferencesAsync` para conservarla. Si tu plantilla ya usa `material_ui`, añade `shared_preferences` desde la carpeta que contiene `pubspec.yaml`.

```bash
flutter pub add shared_preferences
```

El menú llama a `_cambiarModo`. Este método guarda el nombre del modo y actualiza `MaterialApp` con `setState`. Mientras se guarda, la pantalla desactiva el menú para procesar una elección cada vez. Si falla la escritura, muestra un aviso y conserva el tema activo.

```dart
Future<void> _cambiarModo(ThemeMode modo) async {
  await widget.preferencias?.setString(claveTema, modo.name);
  if (!mounted) return;
  setState(() => _modo = modo);
}
```

En `main()`, inicializa Flutter antes de usar el almacenamiento. Lee `modo_tema` antes de llamar a `runApp()` para aplicar la preferencia desde el primer fotograma. Si la clave no existe o contiene un valor desconocido, elige `ThemeMode.system`.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = SharedPreferencesAsync();
  final guardado = await preferencias.getString(claveTema);
  final inicial = ThemeMode.values.firstWhere(
    (modo) => modo.name == guardado,
    orElse: () => ThemeMode.system,
  );
  runApp(MyApp(preferencias: preferencias, temaInicial: inicial));
}
```

Si quieres que el modo dure solo mientras la app está abierta, inicia con `runApp(const MyApp())`. El constructor conserva el modo **Sistema** como valor inicial y el menú sigue funcionando durante la sesión. Para prescindir también de la dependencia, quita el import de `shared_preferences`, el parámetro y el campo `preferencias` de `MyApp`, y la llamada a `setString` en `_cambiarModo`.

## Comprueba los tres modos

| Prueba | Resultado esperado |
| --- | --- |
| Elige **Oscuro** con el sistema en claro. | La pantalla, la barra superior y el botón flotante usan el esquema oscuro. |
| Elige **Claro** con el sistema en oscuro. | La app vuelve al esquema claro. |
| Elige **Sistema** y cambia el modo del dispositivo. | La app sigue la apariencia del sistema. |
| Pulsa **+** un par de veces y cambia de tema. | El número del contador se conserva. |
| Cierra la app por completo y vuelve a abrirla. | El menú recupera el último tema guardado con la configuración completa. El contador vuelve a cero. |

Comprueba que el título y el icono del menú se leen bien en ambos modos. Si algún texto pierde contraste, revisa los colores fijos y el par de roles que pinta su superficie.

## Archivos que debes modificar

| Archivo de tu proyecto | Qué debes hacer |
| --- | --- |
| `lib/main.dart` | Sustituye el contador de la plantilla por el código de la sección siguiente. Incluye las dos paletas, el menú y la lectura de la preferencia guardada. |
| `pubspec.yaml` | Declara `material_ui` y `shared_preferences`. Si la plantilla ya incluye `material_ui`, basta con ejecutar `flutter pub add shared_preferences`. Si te faltan los dos, ejecuta `flutter pub add material_ui shared_preferences`. |
| `pubspec.lock` | Flutter lo actualiza al resolver las dependencias. |

El tema de la interfaz se configura desde Dart. Los recursos de Android e iOS se editan por separado si quieres cambiar también el aspecto del arranque. [Guía de splash screen en Flutter](../flutter-splash-screen/).

## Main Dart completo para copiar y pegar

Pega el bloque en `lib/main.dart` o [abre el archivo Dart](ejemplo/lib/main.dart). Después de añadir las dependencias, ejecuta `flutter run` y abre **Cambiar tema** desde la barra del contador.

```dart
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const claveTema = 'modo_tema';
const colorSemilla = Colors.deepPurple;

final temaClaro = crearTema(Brightness.light);
final temaOscuro = crearTema(Brightness.dark);

ThemeData crearTema(Brightness brillo) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorSemilla,
      brightness: brillo,
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = SharedPreferencesAsync();
  final guardado = await preferencias.getString(claveTema);
  final inicial = ThemeMode.values.firstWhere(
    (modo) => modo.name == guardado,
    orElse: () => ThemeMode.system,
  );
  runApp(MyApp(preferencias: preferencias, temaInicial: inicial));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.preferencias,
    this.temaInicial = ThemeMode.system,
  });

  final SharedPreferencesAsync? preferencias;
  final ThemeMode temaInicial;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _modo = widget.temaInicial;

  Future<void> _cambiarModo(ThemeMode modo) async {
    await widget.preferencias?.setString(claveTema, modo.name);
    if (!mounted) return;
    setState(() => _modo = modo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: _modo,
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        modo: _modo,
        cambiarModo: _cambiarModo,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.modo,
    required this.cambiarModo,
  });

  final String title;
  final ThemeMode modo;
  final Future<void> Function(ThemeMode) cambiarModo;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _guardando = false;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  Future<void> _seleccionarModo(ThemeMode modo) async {
    if (modo == widget.modo || _guardando) return;
    setState(() => _guardando = true);
    try {
      await widget.cambiarModo(modo);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el tema.')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colores.primaryContainer,
        foregroundColor: colores.onPrimaryContainer,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<ThemeMode>(
            tooltip: 'Cambiar tema',
            icon: const Icon(Icons.brightness_6),
            initialValue: widget.modo,
            enabled: !_guardando,
            onSelected: _seleccionarModo,
            itemBuilder: (context) => const [
              PopupMenuItem(value: ThemeMode.system, child: Text('Sistema')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Claro')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Oscuro')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Archivos y referencias

- [Instrucciones y código del ejemplo](ejemplo/README.md).
- [Temas en Flutter](https://docs.flutter.dev/cookbook/design/themes).
- [Persistencia con shared_preferences](https://pub.dev/packages/shared_preferences).
- [Idiomas y traducciones en Flutter](../flutter-idiomas/).
