# Contexto del proyecto

Documento de continuidad entre ordenadores y agentes. Fecha de referencia: 9 de octubre de 2026. El estado de Git y los archivos prevalecen sobre cualquier descripción desactualizada.

## Propósito

David Valdivia Vico, profesor de Informática, comparte herramientas y material educativo. La portada presenta Conversor MarkItDown, un catálogo de tutoriales y apoyo voluntario mediante Ko-fi.

Enlaces públicos:

- Web: https://davavico.es
- Bot: https://t.me/AsistenteInicial2026_bot
- Ko-fi: https://ko-fi.com/dvalvic

El backend del bot no está en este repositorio. Sus límites de tamaño, conservación de archivos y disponibilidad deben confirmarse con su implementación.

## Arquitectura

HTML, CSS y JavaScript sin framework, gestor de paquetes ni compilación. GitHub Pages sirve los archivos estáticos. `CNAME` configura el dominio y `.nojekyll` evita el procesamiento de Jekyll.

Las páginas de tutorial incluyen un artículo `#contenido` con `data-source="contenido.md"`. El script compartido descarga el Markdown con `fetch`, lo convierte con Marked y elimina su primer `h1`, porque la página ya tiene título.

Después resuelve las imágenes relativas al archivo fuente, crea el índice desde los `h2`, asigna identificadores únicos y añade botones para copiar código. Highlight.js resalta los lenguajes cargados en la página. El botón fijo enlaza a `#indice`.

Compose carga Kotlin. Flutter carga Kotlin, Dart y YAML; también contiene bloques Bash y texto. Las versiones actuales son Marked 15.0.7 y Highlight.js 11.9.0 desde jsDelivr.

El Markdown de Flutter conserva la numeración original. Su página activa `data-strip-heading-numbers="true"` para retirarla de los `h2` renderizados. Compose ya tiene títulos sin números en el Markdown.

## Decisiones de interfaz

- Las instrucciones del bot se integran en un desplegable dentro de su tarjeta para mantener la portada compacta; separarlas desorientaba al lector.
- La portada presenta herramienta y aprendizaje en dos columnas (una en móvil), con protagonismo equilibrado.
- Ambas tarjetas de portada recuperan el estilo anterior de tutoriales: degradado suave, iconos y enlace con flecha, sin botón azul. El área principal es un enlace amplio; los detalles desplegables quedan dentro de la tarjeta pero fuera del enlace. Comparten altura y comportamiento. El bloque de apoyo es una franja cálida con icono y botón propio, visualmente secundaria.
- El catálogo usa tarjetas con cabeceras de color, ilustraciones SVG locales en `assets/`, temas y enlaces a cada guía. Los gráficos identificativos son ilustraciones simplificadas, no recursos oficiales de marca.
- Ko-fi tiene un bloque de apoyo propio después de los recursos.
- El catálogo se llama «Tutoriales de desarrollo de apps» y abarca Compose y Flutter.
- Nivel y requisitos son etiquetas de colores, sin acción de botón.
- Hay un botón inferior derecho para volver al índice.
- Los títulos no llevan «Composable X» ni numeración redundante. Esto no afecta a las anotaciones Kotlin.
- Se retiró el ejercicio genérico «Ponlo en práctica» de Compose. En su lugar hay instrucciones al inicio sobre cómo utilizar los ejemplos.
- Flutter incluye una práctica completa del autor que debe conservarse.
- El código tiene fondo oscuro y colores diferenciados. Solo se colorean los tokens reconocidos por Highlight.js; no todos los identificadores reciben una clase.
- Las tablas permiten desplazamiento horizontal en pantallas pequeñas.

## Añadir una guía

1. Crea `tutoriales/<nombre>/contenido.md` y `index.html` usando una página existente como referencia.
2. Adapta título, descripción, requisitos y módulos de lenguaje.
3. Para esta profundidad, usa `../../css/estilos.css`, `../../js/render-markdown.js` y `data-source="contenido.md"`.
4. Añade la tarjeta al catálogo y ajusta la portada si procede.
5. Verifica carga por HTTP, índice, imágenes, enlaces, código y móvil. Evita duplicar números en títulos e índice.

## Límites y pendientes

- Los tutoriales requieren JavaScript y las bibliotecas del CDN; ofrecen enlaces al Markdown como alternativa.
- El Markdown es contenido de autores de confianza y se inserta mediante `innerHTML`. Antes de aceptar contenido de visitantes, añade sanitización apropiada.
- Faltan condiciones confirmadas de conservación de archivos y límites del bot.
- La configuración efectiva de Pages, el plan de GitHub y el DNS se comprueban fuera de este repositorio.
- Revisa Git antes de continuar: este documento no es un registro de commits o publicaciones pendientes.

## Documentación pública y privada

`README.md`, `AGENTS.md` y este documento solo contienen contexto técnico publicable. Los tutoriales `contenido.md` son públicos y necesarios para el renderizado.

Guarda credenciales, datos personales no públicos y notas confidenciales fuera del repositorio y de la carpeta desplegada. Trasládalos entre ordenadores mediante almacenamiento privado adecuado.

`.gitignore` no cifra archivos, no elimina información del historial y no determina por sí solo el contenido de un despliegue. Con publicación estática desde la raíz y `.nojekyll`, considera potencialmente accesibles los archivos incluidos aunque no estén enlazados. Un repositorio privado tampoco convierte automáticamente una web de Pages en privada.
