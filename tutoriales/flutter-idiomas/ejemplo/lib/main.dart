import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';

const claveIdioma = 'idioma_app';

enum IdiomaApp {
  sistema('system', null),
  espanol('es', Locale('es')),
  ingles('en', Locale('en'));

  const IdiomaApp(this.codigo, this.locale);

  final String codigo;
  final Locale? locale;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = SharedPreferencesAsync();
  final guardado = await preferencias.getString(claveIdioma);
  final inicial = IdiomaApp.values.firstWhere(
    (idioma) => idioma.codigo == guardado,
    orElse: () => IdiomaApp.sistema,
  );
  runApp(MyApp(preferencias: preferencias, idiomaInicial: inicial));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.preferencias,
    required this.idiomaInicial,
  });

  final SharedPreferencesAsync preferencias;
  final IdiomaApp idiomaInicial;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late IdiomaApp _idioma = widget.idiomaInicial;

  Future<void> _cambiarIdioma(IdiomaApp idioma) async {
    await widget.preferencias.setString(claveIdioma, idioma.codigo);
    if (!mounted) return;
    setState(() => _idioma = idioma);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _idioma.locale,
      home: AccesoTraducido(
        total: 2,
        idioma: _idioma,
        cambiarIdioma: _cambiarIdioma,
      ),
    );
  }
}

enum EstadoAcceso { correoInvalido, faltaClave, demostracion }

class AccesoTraducido extends StatefulWidget {
  const AccesoTraducido({
    super.key,
    required this.total,
    required this.idioma,
    required this.cambiarIdioma,
  });

  final int total;
  final IdiomaApp idioma;
  final Future<void> Function(IdiomaApp) cambiarIdioma;

  @override
  State<AccesoTraducido> createState() => _AccesoTraducidoState();
}

class _AccesoTraducidoState extends State<AccesoTraducido> {
  String _correo = '';
  String _clave = '';
  EstadoAcceso? _estado;
  bool _guardando = false;

  void _validar() {
    final estado = switch ((_correo.contains('@'), _clave.trim().isNotEmpty)) {
      (false, _) => EstadoAcceso.correoInvalido,
      (true, false) => EstadoAcceso.faltaClave,
      (true, true) => EstadoAcceso.demostracion,
    };
    setState(() => _estado = estado);
  }

  Future<void> _seleccionar(IdiomaApp? idioma) async {
    if (idioma == null || idioma == widget.idioma || _guardando) return;
    setState(() => _guardando = true);
    try {
      await widget.cambiarIdioma(idioma);
    } catch (_) {
      if (mounted) {
        final textos = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(textos.languageSaveError)));
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;
    final mensaje = switch (_estado) {
      EstadoAcceso.correoInvalido => textos.errorEmail,
      EstadoAcceso.faltaClave => textos.errorPassword,
      EstadoAcceso.demostracion => textos.demoAccess,
      null => null,
    };

    return Scaffold(
      appBar: AppBar(title: Text(textos.appTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(textos.language),
            DropdownButton<IdiomaApp>(
              value: widget.idioma,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: IdiomaApp.sistema,
                  child: Text(textos.languageSystem),
                ),
                DropdownMenuItem(
                  value: IdiomaApp.espanol,
                  child: Text(textos.languageSpanish),
                ),
                DropdownMenuItem(
                  value: IdiomaApp.ingles,
                  child: Text(textos.languageEnglish),
                ),
              ],
              onChanged: _guardando ? null : _seleccionar,
            ),
            const SizedBox(height: 24),
            Text(textos.welcome('Ana')),
            Text(textos.noteCount(widget.total)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: textos.email),
              keyboardType: TextInputType.emailAddress,
              onChanged: (valor) => _correo = valor,
            ),
            TextField(
              decoration: InputDecoration(labelText: textos.password),
              obscureText: true,
              onChanged: (valor) => _clave = valor,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _validar, child: Text(textos.signIn)),
            if (mensaje != null) Text(mensaje),
          ],
        ),
      ),
    );
  }
}
