# Splash screen en Android

La pantalla de arranque, o *splash screen*, es la primera imagen que ves al abrir una app desde su icono. En esta guía configurarás el icono y el fondo de esa pantalla en una app de ejemplo llamada «Notas personales». Después podrás comprobar en el emulador cómo da paso a la primera pantalla de Compose.

> **Punto de partida.** Abre un proyecto Empty Activity con Compose que ya se ejecute en el emulador. Ten abierto el manifiesto y localiza el nombre de su tema XML.

## Qué controla cada capa

La splash screen pertenece al arranque de Android. En Android 12 y posteriores, el sistema la muestra en arranques en frío y templados. AndroidX facilita el mismo patrón en versiones anteriores compatibles. Una pantalla de carga de Compose ya forma parte de la interfaz de la app y sirve para esperar datos cuando la aplicación está abierta. Una actividad extra para la splash puede provocar que se vean dos pantallas de arranque seguidas.

<figure class="lesson-figure">
    <img src="https://developer.android.com/static/images/ui/splash-sequence.png" alt="Doce fotogramas del arranque: se toca el icono de la app, aparece la splash screen y por último se muestra la interfaz." loading="lazy" decoding="async">
    <figcaption>La secuencia va desde el toque en el icono hasta el primer fotograma de la app. <a href="https://developer.android.com/develop/ui/views/launch/splash-screen">Fuente: Android Developers</a>.</figcaption>
</figure>

## Añade la dependencia

En `app/build.gradle.kts`, incorpora la dependencia dentro de `dependencies` y sincroniza Gradle. Si tu proyecto ya usa un catálogo de versiones, puedes declarar allí el mismo artefacto.

```kotlin
implementation("androidx.core:core-splashscreen:1.0.1")
```

## Define el icono, el fondo y el tema de destino

<figure class="lesson-figure lesson-figure--compact">
    <img src="https://developer.android.com/static/images/guide/topics/ui/splash-screen/splash-screen-composition.png" alt="Esquema de una pantalla de arranque que señala el icono, su fondo opcional, el área de recorte y el fondo de la ventana." loading="lazy" decoding="async">
    <figcaption>Fíjate en la diferencia entre el fondo opcional del icono y el fondo que ocupa toda la ventana. <a href="https://developer.android.com/develop/ui/views/launch/splash-screen#elements">Fuente: Android Developers</a>.</figcaption>
</figure>

Crea `app/src/main/res/values/splash_themes.xml`. Sustituye `Theme.Notas` por el tema XML normal de tu proyecto. El nombre `windowSplashScreenAnimatedIcon` también admite un recurso estático. Empieza con el icono del proyecto y comprueba su recorte en el emulador.

```xml
<resources>
    <style name="Theme.Notas.Starting" parent="Theme.SplashScreen">
        <item name="windowSplashScreenBackground">@color/splash_background</item>
        <item name="windowSplashScreenAnimatedIcon">@mipmap/ic_launcher</item>
        <item name="postSplashScreenTheme">@style/Theme.Notas</item>
    </style>
</resources>
```

En `res/values/splash_colors.xml`, define el fondo. Puedes repetir el mismo nombre en `res/values-night/splash_colors.xml` con un tono oscuro. Android elige la variante con la configuración nocturna activa en el arranque. El selector de Compose de la guía de temas actúa después y no cambia por sí solo el fondo inicial de Android.

```xml
<resources>
    <color name="splash_background">#F3F0FF</color>
</resources>
```

## Conecta el tema con la actividad

Añade `android:theme="@style/Theme.Notas.Starting"` a la etiqueta de la actividad que ya tiene el filtro `MAIN` y `LAUNCHER`. Conserva su filtro, su nombre y su configuración existente. En Kotlin, instala la splash antes de `super.onCreate()`.

```kotlin
package com.example.notas

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface { Text("Mis notas") }
            }
        }
    }
}
```

## Comprueba el arranque

Fuerza la detención desde Ajustes y abre la app desde su icono. Debes ver el fondo con el icono y, a continuación, «Mis notas». Repítelo con el tema del sistema oscuro y, si dispones de otro emulador, en API 31 o posterior y en una versión anterior compatible. Volver desde recientes con la actividad todavía en memoria no es una prueba de arranque en frío.

Si ves dos pantallas de inicio, comprueba si queda una actividad de splash antigua en el manifiesto. Si aparece un destello al pasar a Compose, compara el fondo de `Theme.Notas` y el de la primera superficie de la app. Evita añadir un retraso fijo. Si necesitas esperar un estado local indispensable, `setKeepOnScreenCondition` puede consultar una bandera rápida; para una espera de red, suele ser preferible mostrar un estado de carga en la interfaz.

## Archivos y referencias

- [Instrucciones y archivos del ejemplo](ejemplo/README.md).
- [SplashScreen en Android](https://developer.android.com/develop/ui/views/launch/splash-screen?hl=es-419#kts).
- [Migrar una pantalla de arranque existente](https://developer.android.com/develop/ui/views/launch/splash-screen/migrate).
- [Temas claro y oscuro en Compose](../compose-temas/).
