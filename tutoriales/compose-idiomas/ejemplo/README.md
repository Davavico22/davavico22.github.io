# Ejemplo de localización

- Integra [las cadenas predeterminadas](res/values/strings.xml) y [la traducción](res/values-en/strings.xml) en las carpetas equivalentes de `app/src/main/res/`. Combina las claves si ya tienes un `strings.xml`.
- Para el selector, añade AndroidX AppCompat (1.6.0 o posterior) y adapta el paquete de [MainActivity.kt](MainActivity.kt) al namespace de tu módulo. La actividad debe usar un tema XML derivado de `Theme.AppCompat`, por ejemplo `Theme.AppCompat.DayNight.NoActionBar`. El tema Compose va en `setContent`.
- Añade el servicio descrito en la guía dentro de `<application>` para que AppCompat guarde el idioma en Android 12 y anteriores.
- Para mostrar la lista de idiomas en los ajustes de Android 13 y posteriores, habilita `generateLocaleConfig` con AGP 8.1 o posterior y copia [resources.properties](res/resources.properties) a `app/src/main/res/`.
- La pantalla simula los mensajes de acceso. Usa datos ficticios. La contraseña se borra si Android recrea la actividad al cambiar el idioma.
