# Idiomas y traducciones en Compose

Si escribes «Entrar» directamente en un botón, el texto se queda en español incluso después de cambiar el idioma del teléfono. En esta guía vas a separar los textos de la interfaz, traducir una pantalla de acceso y darle al usuario tres opciones: español, inglés o el idioma del sistema.

## Separa el texto de la lógica

Un recurso tiene una clave como `sign_in`. Cada traducción conserva la clave y cambia su valor. Android resuelve qué recurso cargar según el idioma de la app. Compose lo muestra con `stringResource`.

| Carpeta bajo `res/` | Configuración |
| --- | --- |
| `values/` | Recursos predeterminados. Aquí usaremos español como respaldo. |
| `values-en/` o `values-b+en/` | Inglés. Elige una de las dos formas para el mismo recurso. |
| `values-es/` | Variante para el idioma español, si la necesitas aparte del respaldo. |
| `values-es-rES/` o `values-b+es+ES/` | Español de España. |
| `mipmap-b+es+ES/` | Ejemplo de un icono alternativo para esa misma región. |

El formato breve usa `-r` antes de la región; el formato BCP 47 de los directorios empieza por `b+`. La etiqueta que se pasa por Kotlin lleva guiones, como `es-ES`.

## Define los mismos recursos en ambos idiomas

**Español predeterminado · `app/src/main/res/values/strings.xml`**

```xml
<resources>
    <string name="app_name">Notas personales</string>
    <string name="email">Correo electrónico</string>
    <string name="password">Contraseña</string>
    <string name="sign_in">Entrar</string>
    <string name="sign_out">Cerrar sesión</string>
    <string name="private_area">Mis notas</string>
    <string name="error_email">Revisa el correo.</string>
    <string name="error_password">Introduce la contraseña.</string>
    <string name="error_access">No se pudo iniciar sesión.</string>
    <string name="language_system">Idioma del sistema</string>
    <string name="language_spanish">Español</string>
    <string name="language_english">Inglés</string>
    <string name="welcome">Hola, %1$s</string>
    <plurals name="note_count">
        <item quantity="one">Tienes %1$d nota</item>
        <item quantity="other">Tienes %1$d notas</item>
    </plurals>
</resources>
```

**Inglés · `app/src/main/res/values-en/strings.xml`**

```xml
<resources>
    <string name="app_name">Personal notes</string>
    <string name="email">Email</string>
    <string name="password">Password</string>
    <string name="sign_in">Sign in</string>
    <string name="sign_out">Sign out</string>
    <string name="private_area">My notes</string>
    <string name="error_email">Check your email.</string>
    <string name="error_password">Enter your password.</string>
    <string name="error_access">Unable to sign in.</string>
    <string name="language_system">System language</string>
    <string name="language_spanish">Spanish</string>
    <string name="language_english">English</string>
    <string name="welcome">Hello, %1$s</string>
    <plurals name="note_count">
        <item quantity="one">You have %1$d note</item>
        <item quantity="other">You have %1$d notes</item>
    </plurals>
</resources>
```

Si falta una traducción, Android puede recurrir a la versión predeterminada. Si falta una clave necesaria en `values/`, una configuración sin alternativa aplicable puede fallar al cargarla. Añade también las descripciones accesibles de tu interfaz a los recursos. El contenido de las notas escritas por el usuario permanece tal y como lo escribió.

## Muestra etiquetas, valores y cantidades

Importa `stringResource` y `pluralStringResource` desde `androidx.compose.ui.res`. En un proyecto con otro namespace, usa su propia clase `R`.

```kotlin
Text(stringResource(R.string.sign_in))
Text(stringResource(R.string.welcome, "Ana"))
Text(pluralStringResource(R.plurals.note_count, total, total))
```

Si `total` vale 1, el último texto dice «Tienes 1 nota». El primer `total` selecciona la forma plural y el segundo sustituye `%1$d`. `%1$s` reserva el primer argumento de texto y permite moverlo en la traducción. Evita concatenar «Hola » con el nombre o aplicar una regla universal como `total == 1` para todos los idiomas. Para un error que deba seguir visible al cambiar de idioma, guarda la clave del recurso en el estado y resuélvela al dibujar la pantalla.

## Activa el idioma de la app en Ajustes

<figure class="lesson-figure">
    <img src="https://developer.android.com/static/images/about/versions/13/app-languages.png" alt="Ajustes de Android 13 con la lista de aplicaciones y la pantalla para elegir el idioma de una app." loading="lazy" decoding="async">
    <figcaption>El selector de Ajustes permite elegir el idioma de una app concreta sin cambiar el del teléfono. <a href="https://developer.android.com/guide/topics/resources/app-languages">Fuente: Android Developers</a>.</figcaption>
</figure>

En Android 13 o posterior, Android muestra un selector de idiomas por app cuando esta declara los idiomas compatibles. Con AGP 8.1 o posterior y `compileSdk` 33 o superior, añade al bloque `android` del módulo:

```kotlin
androidResources { generateLocaleConfig = true }
```

Crea `app/src/main/res/resources.properties` con una línea `unqualifiedResLocale=es`. Gradle toma las demás traducciones de los recursos de la app y sus dependencias. Comprueba la lista generada si incorporas bibliotecas traducidas. Usa una única estrategia: generación automática o declaración manual de `android:localeConfig`.

## Añade un selector dentro de Compose

Para que funcione también en Android 12 y anteriores, añade la dependencia `androidx.appcompat:appcompat` con una versión compatible (mínimo 1.6.0). Cambia la base de tu actividad a `AppCompatActivity` y dale un tema XML de AppCompat. Dentro de la actividad, puedes seguir llamando a `setContent`.

```kotlin
@Composable
private fun SelectorIdioma() {
    val opciones = listOf(
        "" to R.string.language_system,
        "es" to R.string.language_spanish,
        "en" to R.string.language_english
    )

    for ((etiqueta, texto) in opciones) {
        TextButton(onClick = {
            val idiomas = LocaleListCompat.forLanguageTags(etiqueta)
            AppCompatDelegate.setApplicationLocales(idiomas)
        }) {
            Text(stringResource(texto))
        }
    }
}
```

Una lista vacía vuelve al idioma del sistema. AppCompat puede recrear la actividad al cambiar el idioma; al volver a ejecutarse, `stringResource` muestra los textos correspondientes. Para que AppCompat guarde la elección en dispositivos anteriores a Android 13, agrega este servicio dentro de `<application>` en el manifiesto.

```xml
<service
    android:name="androidx.appcompat.app.AppLocalesMetadataHolderService"
    android:enabled="false"
    android:exported="false">
    <meta-data android:name="autoStoreLocales" android:value="true" />
</service>
```

## Comprueba el resultado en el emulador

| Prueba | Qué debes ver |
| --- | --- |
| Sistema en inglés, sin idioma propio | El acceso muestra «Email» y «Sign in». |
| Seleccionar español en la app | Cambian los textos de la pantalla y una nueva validación muestra el error en español. |
| Seleccionar «Idioma del sistema» | La app vuelve a seguir el idioma del dispositivo. |
| Cambiar `total` a 0, 1 y 2 | «0 notas», «1 nota» y «2 notas» con la frase del idioma activo. |
| Aumentar el tamaño de fuente | Los botones y etiquetas conservan el texto legible. |

Cierra y vuelve a abrir la app para comprobar que conserva el idioma elegido. Si el selector no funciona en Android 12 o anteriores, revisa la clase base de la actividad, el tema XML y el servicio de AppCompat.

## Archivos y referencias

- [Instrucciones y archivos del ejemplo](ejemplo/README.md). Incluye una pantalla de acceso de demostración con los imports.
- [Localización de aplicaciones Android](https://developer.android.com/guide/topics/resources/localization).
- [Recursos en Compose](https://developer.android.com/develop/ui/compose/resources).
- [Preferencias de idioma por aplicación](https://developer.android.com/guide/topics/resources/app-languages).
