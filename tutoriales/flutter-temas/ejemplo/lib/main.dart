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
