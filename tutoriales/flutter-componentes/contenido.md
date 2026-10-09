# Componentes fundamentales de Flutter: de Jetpack Compose a Dart


**Objetivos:** interpretar un árbol de widgets, distribuir componentes, gestionar estado local, reconocer equivalentes de Compose y justificar cuándo elegir cada tecnología.

**Cómo utilizar los ejemplos:** los fragmentos visuales se insertan en el `body` de un `Scaffold` o en una lista `children`. Todos utilizan `import 'package:flutter/material.dart';`. Los fragmentos con `setState` requieren una clase `State`; sus variables se indican en comentarios. La práctica final incluye un programa completo, sin paquetes adicionales ni imágenes.

---

## 1. Qué es Flutter

Flutter es un SDK para crear aplicaciones con Dart y compartir buena parte del código entre Android, iOS, web y escritorio. Su interfaz se describe mediante **widgets**: objetos que configuran texto, distribución, interacción o decoración.

La idea central de una interfaz declarativa es la siguiente:

```text
Estado actual → descripción de la interfaz → interacción → nuevo estado
```

En Compose escribimos funciones `@Composable`. En Flutter construimos widgets y devolvemos un árbol desde `build`. Los widgets son configuraciones inmutables; el estado mutable se mantiene por separado.

| Conocimiento en Compose | Concepto aproximado en Flutter |
| --- | --- |
| Función `@Composable` | Widget propio con un método `build` |
| Parámetros del composable | Parámetros del constructor |
| Contenido de una lambda | `child` o lista `children` |
| `Modifier` | Parámetros y widgets como `Padding`, `SizedBox` o `Align` |
| `remember { mutableStateOf(...) }` | Campos de `State` y `setState`, para estado local |
| Recomposición | Reconstrucción con `build`; el mecanismo interno es diferente |
| Elevar el estado | Recibir valores y callbacks desde un ancestro |
| `MaterialTheme` | `ThemeData` y `Theme.of(context)` |
| `LazyColumn` | `ListView.builder` |
| Claves de elementos | `Key`, normalmente `ValueKey` |

Son correspondencias para orientarse, no traducciones automáticas. Una variable normal de Dart no se vuelve observable por utilizarla en `build`.

Referencia: [Flutter para desarrolladores de Jetpack Compose](https://docs.flutter.dev/flutter-for/compose-devs).

## 2. Preparar y ejecutar el proyecto

Instala Flutter siguiendo la [guía oficial](https://docs.flutter.dev/install), junto con las herramientas de la plataforma elegida. Puedes usar Android Studio o VS Code con sus extensiones de Flutter y Dart.

```bash
flutter doctor
flutter create aula_flutter
cd aula_flutter
flutter run
```

`flutter doctor` comprueba el entorno. Si hay varios dispositivos disponibles, usa `flutter devices` y `flutter run -d ID_DEL_DISPOSITIVO`.

| Archivo o carpeta | Función |
| --- | --- |
| `lib/main.dart` | Punto de entrada y código inicial |
| `pubspec.yaml` | Dependencias, recursos y configuración del paquete |
| `test/` | Pruebas de Dart y widgets |
| Carpetas de plataforma, como `android/` e `ios/` | Configuración e integración específicas |

Para compilar iOS localmente se necesita macOS y Xcode. Compartir código no elimina los requisitos de compilación, firma y publicación de cada plataforma.

### Primera aplicación completa

Sustituye `lib/main.dart` por este código:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const AulaApp());

class AulaApp extends StatelessWidget {
  const AulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula Flutter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Hola, Flutter')),
        body: const SafeArea(
          child: Center(child: Text('Una interfaz declarativa con Flutter')),
        ),
      ),
    );
  }
}
```

* **`main` y `runApp`:** inician la aplicación.
* **`MaterialApp`:** configura el tema, la navegación y otros servicios de una aplicación Material.
* **`Scaffold`:** distribuye barra superior, contenido y botón flotante.
* **`BuildContext`:** identifica una ubicación en el árbol. Permite consultar el tema o el navegador de los ancestros; no equivale al `Context` de Android.
* **`super.key`:** permite identificar el widget al actualizar el árbol; no guarda datos por sí solo.
* **`SafeArea`:** aplica separaciones frente a zonas del sistema. No hay que copiar mecánicamente el `innerPadding` de Compose: cada estructura gestiona sus espacios de forma diferente.

## 3. Dart imprescindible para quien conoce Kotlin

| Kotlin | Dart | Observación |
| --- | --- | --- |
| `val nombre = "Ana"` | `final nombre = 'Ana';` | Referencia asignable una sola vez |
| `var contador = 0` | `var contador = 0;` | Variable reasignable con tipo inferido |
| `String?` | `String?` | Tipo que admite `null` |
| `nombre ?: "Sin nombre"` | `nombre ?? 'Sin nombre'` | Alternativa si es nulo |
| `usuario?.nombre` | `usuario?.nombre` | Acceso seguro |
| `fun sumar(a: Int, b: Int): Int` | `int sumar(int a, int b)` | Declaración de función |
| `onClick = { guardar() }` | `onPressed: () { guardar(); }` | Callback |
| `listOf("Ana", "Luis")` | `['Ana', 'Luis']` | En Dart la lista no es inmutable por defecto |
| `"Hola $nombre"` | `'Hola $nombre'` | Interpolación; `${...}` para expresiones |

### `final`, `const` y parámetros nombrados

```dart
final ahora = DateTime.now(); // Valor obtenido durante la ejecución.
const separacion = 16.0;     // Constante evaluable en compilación.

String saludar({required String nombre, int veces = 1}) {
  return List.filled(veces, 'Hola, $nombre').join('\n');
}

// Uso: saludar(nombre: 'Ana', veces: 2);
```

`final` no vuelve inmutable el objeto al que apunta. `const` exige un valor constante y permite reutilizar instancias constantes. Usa constructores `const` para widgets estáticos; no se pueden usar con datos que cambian durante la ejecución.

Dart tiene null safety. Evita añadir `!` indiscriminadamente: afirma que algo no es nulo y puede fallar en ejecución. `late` tampoco significa «nullable»: leer una variable `late` antes de inicializarla produce un error.

### Asincronía

```dart
Future<String> cargarSaludo() async {
  await Future<void>.delayed(const Duration(seconds: 1));
  return 'Datos cargados';
}
```

`Future<T>` representa un resultado futuro. `async` y `await` permiten esperarlo, pero no sustituyen toda la estructura de coroutines, scopes y cancelación de Kotlin. `await` no mueve automáticamente un cálculo pesado a otro hilo; para trabajo intensivo puede ser necesario un isolate.

Referencias: [variables](https://dart.dev/language/variables), [null safety](https://dart.dev/null-safety) y [asincronía en Dart](https://dart.dev/language/async).

## 4. Widgets y estado

* **`StatelessWidget`:** no tiene un objeto `State` mutable propio. Puede reconstruirse al cambiar sus parámetros o dependencias; no significa «interfaz que nunca cambia».
* **`StatefulWidget`:** también es inmutable, pero crea un objeto `State` que conserva datos mientras siga asociado a la misma ubicación e identidad en el árbol.
* **`setState`:** modifica estado local y marca el elemento para reconstrucción. Su callback debe ser síncrono.

### El mismo contador en Compose y Flutter

```kotlin
@Composable
fun Contador() {
    var cuenta by remember { mutableStateOf(0) }
    Button(onClick = { cuenta++ }) {
        Text("Pulsaciones: $cuenta")
    }
}
```

```dart
class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  int cuenta = 0;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => setState(() => cuenta++),
      child: Text('Pulsaciones: $cuenta'),
    );
  }
}
```

No declares `cuenta` dentro de `build`: se reiniciaría en cada ejecución. Tampoco hagas peticiones de red ni cambies estado directamente en `build`; puede ejecutarse muchas veces. Una reconstrucción no implica volver a crear o dibujar todo lo que aparece en pantalla.

### Elevar el estado

Como en Compose, **los valores bajan y los eventos suben**:

```dart
class PreferenciaAvisos extends StatelessWidget {
  const PreferenciaAvisos({
    super.key,
    required this.activa,
    required this.onChanged,
  });

  final bool activa;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Recibir avisos'),
      value: activa,
      onChanged: onChanged,
    );
  }
}
```

El padre guarda el booleano y pasa `onChanged: (valor) => setState(() => avisos = valor)`. Así el componente es reutilizable.

`setState` basta para esta práctica. En aplicaciones mayores se puede separar la lógica en modelos y utilizar mecanismos como `ChangeNotifier` u otras soluciones de estado. Un `ViewModel` de Android no tiene un reemplazo obligatorio único en Flutter.

Ni `State` ni `remember` garantizan persistencia tras cerrar el proceso. Los datos duraderos requieren almacenamiento y la restauración de interfaz requiere un diseño específico.

Referencia: [estado e interfaz declarativa](https://docs.flutter.dev/data-and-backend/state-mgmt/declarative).

## 5. Distribución: de `Modifier` a contenedores

Flutter combina widgets de un solo hijo (`child`) y widgets con varios hijos (`children`). Por ejemplo, `Padding` recibe un hijo; `Column` recibe una lista.

| Compose | Flutter | Precaución |
| --- | --- | --- |
| `Modifier.padding(16.dp)` | `Padding(padding: EdgeInsets.all(16), child: ...)` | El orden de anidación importa |
| `Modifier.size(48.dp)` | `SizedBox(width: 48, height: 48, child: ...)` | El padre sigue imponiendo restricciones |
| `Modifier.fillMaxWidth()` | `SizedBox(width: double.infinity, child: ...)` | Requiere ancho máximo acotado |
| `Modifier.background(...)` | `ColoredBox` o decoración de `Container` | Elige según la decoración necesaria |
| `Modifier.clip(...)` | `ClipRRect` o `ClipOval` | Recortar es distinto de dibujar un borde |
| `Row` / `Column` | `Row` / `Column` | Alineación por ejes principal y transversal |
| `Box` | `Stack`, `Align` o `Center` | Según superposición o alineación |
| `Modifier.weight(1f)` | `Expanded(flex: 1, child: ...)` | Dentro de `Row`, `Column` o `Flex` |
| Separación fija | `SizedBox(height: 8)` o `SizedBox(width: 8)` | Según el eje |

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Row(
    children: [
      const Icon(Icons.school),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Desarrollo de aplicaciones'),
            Text('Ahora también con Flutter'),
          ],
        ),
      ),
    ],
  ),
)
```

En `Row`, el eje principal es horizontal; en `Column`, vertical. `mainAxisAlignment` distribuye en el principal y `crossAxisAlignment` alinea en el transversal.

### Restricciones y unidades

El padre transmite restricciones; el hijo elige un tamaño permitido; el padre lo coloca. `double.infinity` no funciona en cualquier contexto. Una lista dentro de una `Column` suele necesitar `Expanded` para recibir una altura acotada. No pongas un `Expanded` vertical dentro de un scroll de altura ilimitada.

Flutter usa píxeles lógicos: se escribe `16`, sin `.dp`. `TextStyle(fontSize: 24)` también usa valores lógicos y `Text` aplica el escalado de texto del entorno. No multipliques manualmente por la densidad ni desactives el escalado para que «quepa» la interfaz.

El anidamiento cambia el resultado: `Padding(child: ColoredBox(...))` deja separación fuera del fondo; `ColoredBox(child: Padding(...))` colorea también esa separación.

Referencias: [layouts](https://docs.flutter.dev/ui/layout) y [restricciones](https://docs.flutter.dev/ui/layout/constraints).

---

## 6. Text

* **Qué es:** widget que muestra una cadena de texto.
* **Uso:** títulos, mensajes y etiquetas.
* **Equivalente en Compose:** `Text`.

### Parámetros principales

* **Primer argumento:** contenido textual; es posicional, no `text:`.
* **`style`:** `TextStyle` con `fontSize`, `fontWeight` y `color`.
* **`textAlign`:** alineación dentro del espacio disponible.
* **`maxLines` y `overflow`:** limitan líneas y definen el desbordamiento.

```dart
const Padding(
  padding: EdgeInsets.all(16),
  child: Text(
    '¡Bienvenidos al módulo de DAM!',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
)
```

**Resultado esperado:** título en negrita, con separación y un máximo de dos líneas. Para utilizar estilos del tema: `Theme.of(context).textTheme.titleLarge`.

## 7. Icon e IconButton

* **Qué es:** `Icon` muestra un símbolo; `IconButton` lo convierte en una acción.
* **Uso:** favoritos, búsqueda y navegación.
* **Equivalentes:** `Icon` e `IconButton`.

### Parámetros principales

* **Primer argumento de `Icon`:** un `IconData`, por ejemplo `Icons.favorite`.
* **`size` y `color`:** tamaño y color.
* **`semanticLabel`:** descripción del icono cuando aporta información.
* **`onPressed` y `tooltip` de `IconButton`:** acción y etiqueta de ayuda.

```dart
IconButton(
  tooltip: 'Añadir a favoritos',
  onPressed: () { /* Guardar favorito. */ },
  icon: const Icon(Icons.favorite_border, color: Colors.red, size: 32),
)
```

**Resultado esperado:** favorito pulsable con etiqueta descriptiva. Evita duplicar innecesariamente la etiqueta del botón en su icono interior.

Los `VectorDrawable` XML de Android no se cargan directamente como iconos de Flutter. `Icons` ofrece su catálogo integrado; otros formatos, como SVG, pueden requerir paquetes o conversión. No traslades automáticamente las recomendaciones sobre dependencias de iconos de Compose a Flutter.

## 8. Image

* **Qué es:** widget que muestra imágenes.
* **Uso:** fotografías, avatares y banners.
* **Equivalente:** `Image`; `fit` cumple una función similar a `contentScale`.

### Recursos locales

Crea `assets/imagenes/perfil.png` y declara la carpeta dentro del bloque `flutter` existente en `pubspec.yaml`. Conserva el resto de su configuración y respeta la indentación:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/imagenes/
```

Ejecuta `flutter pub get` después de modificar la configuración. Añade una imagen llamada `perfil.png` a la carpeta indicada antes de ejecutar el ejemplo.

```dart
ClipOval(
  child: Image.asset(
    'assets/imagenes/perfil.png',
    width: 100,
    height: 100,
    fit: BoxFit.cover,
    semanticLabel: 'Fotografía del alumno',
  ),
)
```

### Parámetros y comparación

| Compose | Flutter | Resultado |
| --- | --- | --- |
| `ContentScale.Crop` | `BoxFit.cover` | Rellena manteniendo proporción y recorta sobrante |
| `ContentScale.Fit` | `BoxFit.contain` | Muestra la imagen entera; puede dejar huecos |
| `ContentScale.FillBounds` | `BoxFit.fill` | Estira y puede deformar |
| `ContentScale.FillWidth` | `BoxFit.fitWidth` | Ajusta por ancho |
| `contentDescription` | `semanticLabel` | Describe una imagen informativa |
| Descripción `null` para decoración | `excludeFromSemantics: true` | Excluye la imagen decorativa del árbol semántico |

**Resultado esperado:** avatar circular. `Image.network` carga imágenes remotas; contempla carga y errores con `loadingBuilder` y `errorBuilder`. La plataforma y las políticas del servidor también condicionan el acceso.

Referencia: [recursos e imágenes](https://docs.flutter.dev/ui/assets/assets-and-images).

## 9. Buttons

* **Qué son:** widgets para ejecutar acciones.
* **Uso:** guardar, confirmar o cancelar.
* **Equivalentes:** `Button`, `OutlinedButton`, `TextButton` y `ElevatedButton`.

### Parámetros principales

* **`onPressed`:** callback; con `null` queda deshabilitado.
* **`child`:** contenido, normalmente un `Text`.
* **`style`:** personalización con `ButtonStyle` o `styleFrom`.

```dart
SizedBox(
  width: double.infinity,
  child: FilledButton(
    onPressed: () { /* Guardar datos. */ },
    style: FilledButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    child: const Text('Guardar datos'),
  ),
)
```

**Resultado esperado:** botón relleno que ocupa el ancho disponible. Para deshabilitar según un formulario: `onPressed: formularioValido ? guardar : null`.

| Intención | Flutter |
| --- | --- |
| Acción destacada con relleno | `FilledButton` |
| Acción con elevación | `ElevatedButton` |
| Acción con contorno | `OutlinedButton` |
| Acción de texto | `TextButton` |

## 10. FloatingActionButton

* **Qué es:** botón destacado para la acción principal de la pantalla.
* **Uso:** añadir un alumno o crear un registro.
* **Equivalente:** `FloatingActionButton` dentro de `Scaffold`.

### Parámetros principales

`onPressed` ejecuta la acción; `tooltip` la describe; `backgroundColor` y `foregroundColor` controlan colores; `child` contiene el icono.

```dart
Scaffold(
  appBar: AppBar(title: const Text('Alumnos')),
  body: const Center(child: Text('Listado de alumnos')),
  floatingActionButton: FloatingActionButton(
    tooltip: 'Añadir alumno',
    onPressed: () { /* Abrir formulario. */ },
    child: const Icon(Icons.add),
  ),
)
```

**Resultado esperado:** botón de añadir situado por `Scaffold` sobre el contenido. `FloatingActionButton.extended` permite icono y texto.

## 11. AppBar y Scaffold

* **Qué es:** `AppBar` es la barra superior; `Scaffold` organiza la pantalla.
* **Uso:** título, navegación y acciones.
* **Equivalentes:** `TopAppBar` y `Scaffold`.

### Parámetros principales

* **`title`:** widget del título.
* **`leading`:** acción al inicio, similar a `navigationIcon`.
* **`actions`:** lista de widgets al final.
* **`backgroundColor` y `foregroundColor`:** colores de la barra y su contenido.

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('Listado de alumnos'),
    actions: [
      IconButton(
        tooltip: 'Buscar alumno',
        onPressed: () { /* Abrir búsqueda. */ },
        icon: const Icon(Icons.search),
      ),
    ],
  ),
  body: const SafeArea(child: Center(child: Text('Contenido'))),
)
```

**Resultado esperado:** título y búsqueda en la parte superior. Con navegación, `AppBar` puede inferir un botón de retroceso; no añadas una flecha sin una acción válida.

## 12. Badge

* **Qué es:** indicador superpuesto a otro widget.
* **Uso:** mensajes pendientes o elementos de un carrito.
* **Equivalente:** combinación `BadgedBox` y `Badge`.

### Parámetros principales

`label` contiene el contador; `child`, el widget decorado; `isLabelVisible` controla la visibilidad. `Badge.count` simplifica un contador numérico.

```dart
IconButton(
  tooltip: 'Notificaciones: 3 pendientes',
  onPressed: () { /* Abrir notificaciones. */ },
  icon: const Badge(
    label: Text('3'),
    child: Icon(Icons.notifications),
  ),
)
```

**Resultado esperado:** campana con contador. Comunica su significado mediante una descripción accesible, sin depender solo del color.

## 13. Switch

* **Qué es:** selector binario.
* **Uso:** activar avisos o preferencias.
* **Equivalente:** `Switch`.

### Parámetros principales

`value` representa el estado y `onChanged` recibe el nuevo valor. El widget no actualiza por sí solo la variable del padre.

```dart
// Campo del State: bool avisos = false;
SwitchListTile(
  title: const Text('Recibir notificaciones'),
  value: avisos,
  onChanged: (valor) => setState(() => avisos = valor),
)
```

**Resultado esperado:** interruptor con etiqueta y fila pulsable. `Switch` ofrece solo el control; `SwitchListTile` integra texto y selección.

## 14. TextField y TextFormField

* **Qué son:** campos de entrada de texto.
* **Uso:** formularios y búsquedas.
* **Equivalentes:** `TextField` y `OutlinedTextField`; en Flutter el borde se configura con `InputDecoration`.

### Parámetros principales

* **`onChanged`:** recibe el texto al editarlo.
* **`controller`:** permite leer y modificar texto, selección y otros datos de edición.
* **`decoration`:** etiqueta, ayuda, iconos y borde.
* **`keyboardType`:** teclado sugerido; no valida la entrada.
* **`obscureText`:** oculta visualmente una contraseña.

```dart
// Campo del State: String nombre = '';
TextField(
  decoration: const InputDecoration(
    labelText: 'Nombre completo',
    border: OutlineInputBorder(),
  ),
  onChanged: (valor) => setState(() => nombre = valor),
)
```

**Resultado esperado:** campo con borde y etiqueta. A diferencia del patrón `value` / `onValueChange` de Compose, `TextField` puede gestionar internamente su edición; `onChanged` permite reflejarla en nuestro modelo.

### Controlador y ciclo de vida

Para limpiar o cambiar el texto desde código, guarda el controlador en `State`, nunca lo crees dentro de `build`:

```dart
// Miembros de una clase State:
final nombreController = TextEditingController();

@override
void dispose() {
  nombreController.dispose();
  super.dispose();
}

// Dentro de build: TextField(controller: nombreController)
// Desde una acción: nombreController.clear();
```

Para validar usa `Form` con `TextFormField` y un `validator`. La práctica final muestra ese flujo sin controlador.

## 15. Card

* **Qué es:** contenedor Material para agrupar información.
* **Uso:** ficha de alumno, producto o noticia.
* **Equivalente:** `Card`.

### Parámetros principales

`child` contiene la información; `elevation` controla elevación; `shape` configura el contorno; `margin` separa la tarjeta de su entorno. Para espacio interior añade `Padding`.

```dart
const Card(
  elevation: 2,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ana García', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('2.º de DAM'),
      ],
    ),
  ),
)
```

**Resultado esperado:** ficha con nombre y curso. Para una tarjeta interactiva combina `Card` e `InkWell` con `onTap`; comprueba el recorte del efecto si personalizas su forma.

## 16. ProgressIndicator

* **Qué es:** indicador de una operación en curso.
* **Uso:** carga o subida de datos.
* **Equivalentes:** `CircularProgressIndicator` y `LinearProgressIndicator`.

### Parámetros principales

`value: null` indica progreso indeterminado; un valor entre `0.0` y `1.0` representa una fracción conocida. `semanticsLabel` y `semanticsValue` ayudan a comunicarlo a lectores de pantalla.

```dart
const Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    CircularProgressIndicator(semanticsLabel: 'Cargando alumnos'),
    SizedBox(height: 16),
    LinearProgressIndicator(
      value: 0.65,
      semanticsLabel: 'Subiendo archivo',
      semanticsValue: '65 por ciento',
    ),
  ],
)
```

**Resultado esperado:** círculo de espera y barra al 65 %. No inventes un porcentaje si la operación no proporciona progreso medible.

## 17. Checkbox

* **Qué es:** casilla de selección independiente.
* **Uso:** aceptar condiciones o marcar varias opciones.
* **Equivalente:** `Checkbox`.

### Parámetros principales

`value` indica selección; `onChanged` recibe un `bool?`. Con `tristate: true` también se permite el estado nulo. Para un modelo binario podemos resolver el nullable con `?? false`.

```dart
// Campo del State: bool aceptado = false;
CheckboxListTile(
  title: const Text('Acepto los términos'),
  value: aceptado,
  controlAffinity: ListTileControlAffinity.leading,
  onChanged: (valor) => setState(() => aceptado = valor ?? false),
)
```

**Resultado esperado:** casilla con texto y fila interactiva. Igual que en Compose, `Checkbox` aislado no incluye una etiqueta; `CheckboxListTile` evita construir manualmente la fila.

## 18. Radio y RadioGroup

* **Qué son:** opciones excluyentes de un mismo grupo.
* **Uso:** seleccionar turno o modalidad.
* **Equivalente:** varios `RadioButton` controlados por una selección.

### Parámetros principales

En la API actual, `RadioGroup<T>` centraliza `groupValue` y `onChanged`; cada `Radio` o `RadioListTile` declara su `value`. El tipo genérico debe coincidir en todo el grupo.

```dart
// Campo del State: String turno = 'mañana';
RadioGroup<String>(
  groupValue: turno,
  onChanged: (valor) {
    if (valor != null) {
      setState(() => turno = valor);
    }
  },
  child: const Column(
    children: [
      RadioListTile<String>(value: 'mañana', title: Text('Mañana')),
      RadioListTile<String>(value: 'tarde', title: Text('Tarde')),
    ],
  ),
)
```

**Resultado esperado:** seleccionar un turno desmarca el otro. Este ejemplo requiere Flutter 3.35 o posterior, que incluye `RadioGroup`. Los tutoriales antiguos pasan `groupValue` y `onChanged` a cada radio, un enfoque deprecado en versiones recientes. Consulta la [migración oficial](https://docs.flutter.dev/release/breaking-changes/radio-api-redesign).

## 19. DatePicker

* **Qué es:** selector de fecha, normalmente mostrado como diálogo.
* **Uso:** reservas, cumpleaños o fechas de matrícula.
* **Equivalente:** `DatePicker` dentro de un diálogo. Flutter también ofrece `CalendarDatePicker` para integrarlo en la pantalla.

### Parámetros principales

`showDatePicker` recibe `context`, `firstDate`, `lastDate` e `initialDate`. La fecha inicial debe estar dentro del intervalo. Devuelve `Future<DateTime?>`: `null` significa cancelación.

```dart
// Campo del State: DateTime? fecha;
// Método de la clase State:
Future<void> elegirFecha() async {
  final elegida = await showDatePicker(
    context: context,
    initialDate: fecha ?? DateTime(2026, 9, 1),
    firstDate: DateTime(2020),
    lastDate: DateTime(2035, 12, 31),
  );
  if (!mounted || elegida == null) return;
  setState(() => fecha = elegida);
}

// Widget: FilledButton(onPressed: elegirFecha, child: const Text('Elegir fecha'))
```

**Resultado esperado:** diálogo con calendario; al confirmar se guarda la fecha. Tras el `await`, `mounted` comprueba que este `State` sigue en el árbol antes de actualizarlo.

Compose expone la selección mediante su estado del picker; aquí recibimos un resultado asíncrono. Para fechas de calendario no conviertas automáticamente a UTC sin decidir cómo se guardarán y mostrarán.

## 20. TimePickerDialog

* **Qué es:** diálogo para elegir una hora.
* **Uso:** alarmas o tutorías.
* **Equivalente:** `TimePicker` alojado en un diálogo.

### Parámetros principales

`showTimePicker` recibe `context` e `initialTime`. Devuelve `Future<TimeOfDay?>`; cancelar devuelve `null`.

```dart
// Campo del State: TimeOfDay? hora;
// Método de la clase State:
Future<void> elegirHora() async {
  final elegida = await showTimePicker(
    context: context,
    initialTime: hora ?? const TimeOfDay(hour: 12, minute: 30),
  );
  if (!mounted || elegida == null) return;
  setState(() => hora = elegida);
}

// En build: Text(hora?.format(context) ?? 'Sin hora seleccionada')
```

**Resultado esperado:** selector de hora según la configuración correspondiente del entorno. `TimeOfDay` representa hora y minuto, no una fecha completa ni una zona horaria.

Los textos que escribimos pueden estar en español mientras los controles del framework estén en otro idioma. Para localizar la aplicación configura `flutter_localizations`, `localizationsDelegates` y `supportedLocales` siguiendo la [guía de internacionalización](https://docs.flutter.dev/ui/internationalization).

---

## 21. Listas y navegación

### ListView.builder frente a LazyColumn

Construye elementos bajo demanda, útil para listados largos:

```dart
final alumnos = ['Ana', 'Luis', 'Marta'];

// Dentro del body del Scaffold:
ListView.builder(
  itemCount: alumnos.length,
  itemBuilder: (context, index) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(alumnos[index]),
    );
  },
)
```

Si está dentro de una `Column`, normalmente envuélvelo en `Expanded`. Para listas editables añade claves basadas en un identificador estable, no en el índice ni en un nombre que pueda repetirse.

### Navegar a otra pantalla

Para dos pantallas sencillas podemos empezar con `Navigator.push` y `Navigator.pop`:

```dart
// Desde un onPressed, con un context bajo MaterialApp:
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Detalle del alumno')),
      body: const Center(child: Text('Información del alumno')),
    ),
  ),
);

// Para volver desde el detalle: Navigator.of(context).pop();
```

El objetivo es similar a navegar con un `NavController`, pero las API son distintas. Para enlaces profundos, URL de navegador y navegación compleja estudia `Router` o una solución como `go_router`.

Referencia: [navegación y rutas](https://docs.flutter.dev/ui/navigation).

## 22. Práctica guiada: ficha de matrícula

**Objetivo:** reunir entrada de texto, validación, selección, estado, tarjetas y mensajes. Este programa es independiente de los fragmentos anteriores, no necesita imágenes ni paquetes adicionales y se puede copiar completo a `lib/main.dart`.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const AulaApp());

class AulaApp extends StatelessWidget {
  const AulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrícula DAM',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MatriculaPage(),
    );
  }
}

class MatriculaPage extends StatefulWidget {
  const MatriculaPage({super.key});

  @override
  State<MatriculaPage> createState() => _MatriculaPageState();
}

class _MatriculaPageState extends State<MatriculaPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  bool _avisos = true;
  bool _aceptado = false;
  int _matriculas = 0;

  void _guardar() {
    final valido = _formKey.currentState?.validate() ?? false;
    if (!valido || !_aceptado) return;

    setState(() => _matriculas++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Matrícula registrada: ${_nombre.trim()}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrícula DAM'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Semantics(
              label: '$_matriculas matrículas registradas',
              excludeSemantics: true,
              child: Badge(
                isLabelVisible: _matriculas > 0,
                label: Text('$_matriculas'),
                child: const Icon(Icons.school),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ficha del alumno',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) => setState(() => _nombre = valor),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Introduce el nombre del alumno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Recibir avisos del curso'),
                  value: _avisos,
                  onChanged: (valor) => setState(() => _avisos = valor),
                ),
                CheckboxListTile(
                  title: const Text('Acepto las condiciones de matrícula'),
                  value: _aceptado,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (valor) {
                    setState(() => _aceptado = valor ?? false);
                  },
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nombre.trim().isEmpty
                              ? 'Alumno sin nombre'
                              : _nombre.trim(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(_avisos ? 'Avisos activados' : 'Avisos desactivados'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _aceptado ? _guardar : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Registrar matrícula'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acepta las condiciones para habilitar el registro.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Comportamiento de la aplicación

1. El nombre actualiza la tarjeta al escribir: cambia el estado y se reconstruye la interfaz.
2. El interruptor actualiza el resumen de avisos.
3. El botón permanece deshabilitado hasta aceptar las condiciones.
4. Registrar un nombre vacío muestra el mensaje del `validator`; devolver `null` significa que el campo es válido.
5. Un registro válido incrementa el badge y muestra un `SnackBar`.
6. El formulario puede desplazarse al reducir la ventana o mostrar el teclado.

El registro es una simulación en memoria: cada pulsación válida aumenta el contador y no escribe en una base de datos.

### Ampliaciones propuestas

1. Añadir turno con `RadioGroup` y mostrarlo en la tarjeta.
2. Añadir fecha y hora de tutoría con los selectores anteriores.
3. Extraer la tarjeta a un `StatelessWidget` que reciba datos por constructor.
4. Crear una lista de matrículas con identificadores estables y `ListView.builder`.
5. Implementar pantalla de detalle y navegación de vuelta.
6. Simular carga con `Future.delayed`, deshabilitar el botón durante la espera y mostrar progreso. Comprobar `mounted` tras el `await`.

## 23. Flutter frente a Jetpack Compose: ventajas e inconvenientes

La comparación se centra en **Flutter y Jetpack Compose para Android**. **Compose Multiplatform** permite compartir interfaces en otras plataformas y debe evaluarse por separado; no sería correcto afirmar que toda la familia Compose está limitada a Android.

| Aspecto | Flutter | Jetpack Compose para Android |
| --- | --- | --- |
| Lenguaje | Dart; añade un lenguaje al aprendizaje | Kotlin; reutiliza el conocimiento previo |
| Destinos | SDK orientado a móvil, web y escritorio | Toolkit para Android; para compartir UI se estudia Compose Multiplatform |
| Interfaz | Motor de renderizado y widgets propios; admite integración de vistas nativas | UI declarativa integrada con Android |
| Acceso a la plataforma | Plugins y código específico mediante canales u otros mecanismos | Acceso directo a las API de Android desde Kotlin |
| Diseño | Facilita compartir diseño; ofrece widgets Material y Cupertino | Material y personalización en el ecosistema Android |
| Distribución | Árbol de widgets, restricciones y contenedores | Composables, restricciones y `Modifier` |
| Estado local | `State` y `setState`, entre otras herramientas | Estado observable y recomposición |
| Iteración | Hot reload para muchos cambios de Dart en desarrollo | Previews y herramientas de actualización de Android Studio, según versión y cambio |
| Dependencias | Paquetes de pub.dev; verificar soporte por plataforma | Librerías Kotlin/Android; verificar compatibilidad y mantenimiento |
| Rendimiento | Depende de construcción, layout, pintura, datos y plataforma | Depende de recomposición, layout, dibujo, datos y dispositivo |

### Ventajas prácticas de Flutter

* **Compartir interfaz y lógica:** puede reducir duplicación cuando se necesitan varias plataformas con una experiencia común.
* **Control visual:** facilita interfaces personalizadas y animaciones coherentes entre destinos.
* **Iteración rápida:** hot reload permite revisar muchos cambios conservando estado, dentro de sus límites.
* **Transferencia de conocimientos:** composición, estado elevado y callbacks resultan familiares para quien conoce Compose.

### Inconvenientes y costes de Flutter

* **Aprendizaje adicional:** Dart, restricciones, ciclo de vida, herramientas y empaquetado por plataforma.
* **Integración específica:** algunas funciones necesitan un plugin mantenido o código Kotlin/Swift; no todos los paquetes cubren los mismos destinos.
* **Tamaño y recursos:** incluir motor y recursos tiene costes; mide compilaciones de producción equivalentes antes de decidir.
* **Adaptación:** compartir widgets no resuelve automáticamente accesibilidad, teclado, ratón, permisos, navegación ni convenciones de cada sistema.
* **Mantenimiento:** una actualización común puede afectar varios destinos; hay que probar cada uno.

### Cuándo elegir cada opción

* **Solo Android y mucha integración con el sistema:** Compose suele encajar por el acceso directo al ecosistema y al código Kotlin existente.
* **Android e iOS con diseño común y equipo compartido:** Flutter puede reducir duplicación si los plugins y requisitos de cada plataforma encajan.
* **Equipo con una base importante en Kotlin que quiere compartir UI:** evaluar también Compose Multiplatform.
* **Web orientada a documentos y posicionamiento en buscadores:** evaluar tecnologías web convencionales antes de asumir que compartir toda la UI con Flutter compensa.

No hay un ganador universal de rendimiento o productividad. Implementa una pantalla representativa y mide en dispositivos objetivo con modos de producción o perfilado adecuados; debug no sirve para clasificar tecnologías.

Fuentes: [arquitectura de Flutter](https://docs.flutter.dev/resources/architectural-overview), [canales de plataforma](https://docs.flutter.dev/platform-integration/platform-channels), [hot reload y sus límites](https://docs.flutter.dev/tools/hot-reload), [Compose en Android](https://developer.android.com/compose) y [Compose Multiplatform](https://www.jetbrains.com/compose-multiplatform/).

## 24. Errores frecuentes al venir de Compose

| Error | Motivo y corrección |
| --- | --- |
| Buscar `Modifier` en todos los widgets | Combinar parámetros y contenedores |
| Cambiar una variable y esperar una actualización | Utilizar `setState` o el mecanismo observable elegido |
| Guardar estado dentro de `build` | Moverlo al objeto `State` o a un modelo externo |
| Creer que `StatelessWidget` no se reconstruye | También responde a parámetros y dependencias |
| Crear un controlador en cada `build` | Crearlo una vez en `State` y liberarlo en `dispose` |
| Ejecutar peticiones desde `build` | Iniciarlas en el ciclo de vida o como respuesta a eventos |
| Actualizar estado tras desmontar la pantalla | Comprobar `mounted` tras una espera y cancelar recursos cuando proceda |
| Usar `Expanded` dentro de un scroll vertical | Revisar restricciones: ese eje no tiene altura máxima finita |
| Texto largo en un `Row` sin espacio flexible | Usar `Expanded` o `Flexible` según el diseño |
| Esperar que hot reload reinicie todo | No vuelve a ejecutar `main` ni `initState`; algunos cambios requieren reinicio |
| Copiar `.dp`, `.sp` o `R.drawable` | Usar unidades lógicas y recursos de `pubspec.yaml` |
| Suponer que una UI compartida se adapta sola | Probar tamaños, accesibilidad e interacciones por destino |

## 25. Repaso

Repasa los siguientes conceptos:

* La diferencia entre el widget inmutable y su objeto `State`.
* Por qué `setState` y `remember` no son equivalentes exactos.
* Cómo sustituir una cadena de `Modifier` con widgets anidados.
* Por qué una lista en una columna necesita altura acotada.
* Cómo se deshabilita un botón y quién actualiza un `Switch`.
* Qué ocurre al cancelar un selector de fecha.
* Qué código se comparte y qué trabajo sigue siendo específico de plataforma.

Para comprobar el proyecto: ejecutar `flutter analyze`, abrir la aplicación y recorrer los seis comportamientos de la práctica. Revisar también ventana estrecha, texto ampliado y accesibilidad. Si se conserva el test de `flutter create`, habrá que adaptarlo a esta pantalla: el contador de la plantilla ya no existe.

## Referencias de consulta

* [Catálogo oficial de widgets](https://docs.flutter.dev/ui/widgets).
* [Referencia de componentes Material](https://api.flutter.dev/flutter/material/material-library.html).
* [Tutorial oficial de Flutter](https://docs.flutter.dev/learn/pathway/tutorial).
* [Lenguaje Dart](https://dart.dev/language).
