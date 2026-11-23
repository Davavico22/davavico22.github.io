# Temas claro y oscuro en Compose

Una tarjeta con texto negro fijo puede leerse bien en modo claro y desaparecer sobre un fondo oscuro. La solución empieza por asignar colores a su función en la interfaz. En Notas personales vas a definir dos esquemas de Material 3 y a guardar la elección del usuario.

## Diseña con pares de color

<figure class="lesson-figure">
    <img src="https://developer.android.com/static/images/design/ui/mobile/themes-2-light-and-dark-content.png" alt="La misma pantalla de una aplicación en modo claro y oscuro, con fondos y textos adaptados en cada versión." loading="lazy" decoding="async">
    <figcaption>Compara cómo cambian las superficies y el contraste del texto al pasar de claro a oscuro, aunque el contenido sea el mismo. <a href="https://developer.android.com/design/ui/mobile/guides/styles/themes">Fuente: Android Developers</a>.</figcaption>
</figure>

`MaterialTheme` reúne color, tipografía y formas. Sus componentes usan roles como `primary` para acciones y `onPrimary` para contenido sobre ese color. Conserva el par al personalizar un componente.

| Par | Dónde usarlo |
| --- | --- |
| `primary` / `onPrimary` | Fondo y texto de una acción destacada. |
| `primaryContainer` / `onPrimaryContainer` | Fondo y contenido de un bloque destacado con menor énfasis. |
| `surface` / `onSurface` | Superficie principal y texto que se lee sobre ella. |

Usa [Material Theme Builder](https://www.figma.com/community/plugin/1034969338659738588/material-theme-builder) para explorar pares claros y oscuros a partir de un color de marca. [Coolors](https://coolors.co/) sirve para explorar combinaciones iniciales. Antes de integrar una paleta, comprueba los pares reales de fondo y texto. Una paleta que se ve bien en conjunto puede perder contraste en un componente concreto.

## Crea dos esquemas de Material 3

Empieza por los roles que necesita tu pantalla. Los roles que no se especifican mantienen los valores predeterminados de Material 3. Si los demás componentes también deben seguir la marca, completa el esquema de ambos modos.

```kotlin
private val Claro = lightColorScheme(
    primary = Color(0xFF5343AA),
    onPrimary = Color.White,
    primaryContainer = Color(0xFFE7DFFF),
    onPrimaryContainer = Color(0xFF1C0060),
    surface = Color(0xFFFFFBFF),
    onSurface = Color(0xFF1C1B20)
)

private val Oscuro = darkColorScheme(
    primary = Color(0xFFC9BFFF),
    onPrimary = Color(0xFF2C1975),
    primaryContainer = Color(0xFF433190),
    onPrimaryContainer = Color(0xFFE7DFFF),
    surface = Color(0xFF141318),
    onSurface = Color(0xFFE6E1E9)
)
```

## Aplica el tema a toda la interfaz

Declara tres modos: sistema, claro y oscuro. El sistema consulta `isSystemInDarkTheme()`; los otros dos usan el esquema elegido. Envuelve tu pantalla principal con `TemaNotas` para que `Button`, `Card` y otros componentes hereden sus colores. Si personalizas una superficie, usa su par de roles y toma los estilos de texto de `MaterialTheme.typography`.

```kotlin
@Composable
private fun TemaNotas(modo: ModoTema, contenido: @Composable () -> Unit) {
    val oscuro = when (modo) {
        ModoTema.SISTEMA -> isSystemInDarkTheme()
        ModoTema.CLARO -> false
        ModoTema.OSCURO -> true
    }

    MaterialTheme(
        colorScheme = if (oscuro) Oscuro else Claro,
        typography = Typography(),
        content = contenido
    )
}
```

Si tu plantilla activa el color dinámico en Android 12 o posterior, revisa esa rama antes de probar tus colores: un esquema dinámico toma sus colores del sistema y puede ocultar los cambios de tu paleta de marca. Este ejemplo aplica siempre la paleta definida arriba.

## Cambia el modo y guarda la elección

En el ejemplo, la actividad lee la preferencia al crear la pantalla. El selector cambia el estado de Compose para actualizar la interfaz al instante y también escribe una clave estable. Así, la elección sobrevive a un reinicio de la app. Para la práctica usamos una sola preferencia; si tu proyecto ya tiene DataStore para sus ajustes, guárdala allí.

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val preferencias = getSharedPreferences("apariencia", MODE_PRIVATE)
        val guardado = preferencias.getString("modo_tema", null)
        val inicial = ModoTema.entries.firstOrNull { it.clave == guardado }
            ?: ModoTema.SISTEMA

        setContent {
            var modo by remember { mutableStateOf(inicial) }

            TemaNotas(modo) {
                PantallaTema(modo) { nuevoModo ->
                    modo = nuevoModo
                    preferencias.edit().putString("modo_tema", nuevoModo.clave).apply()
                }
            }
        }
    }
}
```

Cada radio llama a `cambiarModo(opcion)`. El tema se vuelve a calcular con el nuevo valor sin reiniciar manualmente la actividad. Guarda claves como `dark` y traduce las etiquetas por separado si combinas esta guía con la de idiomas.

## Comprueba los tres modos

| Prueba | Resultado esperado |
| --- | --- |
| Elige Oscuro con el sistema en claro | La pantalla y la tarjeta adoptan el esquema oscuro. |
| Elige Claro con el sistema en oscuro | Los roles vuelven al esquema claro. |
| Elige Sistema y cambia el modo del emulador | La app sigue el ajuste del dispositivo. |
| Fuerza la detención y abre de nuevo | Se recupera la última opción guardada. |

Comprueba texto, estados seleccionados y botones en ambos modos. Si sigue habiendo texto ilegible, busca colores fijos como `Color.Black` en la pantalla e inspecciona qué color se aplica al fondo. El tema de Compose afecta a su interfaz; el tema XML de la pantalla de arranque se configura por separado.

## Archivos y referencias

- [Instrucciones y archivos del ejemplo](ejemplo/README.md). Incluye paletas, selector y persistencia en un solo archivo Kotlin.
- [Material 3 en Compose](https://developer.android.com/develop/ui/compose/designsystems/material3).
- [Idiomas y traducciones en Compose](../compose-idiomas/).
