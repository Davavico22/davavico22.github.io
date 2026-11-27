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
