# Instrucciones para agentes

Lee primero `README.md` y `docs/CONTEXTO.md`. Revisa `git status --short` y los últimos commits; conserva los cambios existentes del usuario. Comunícate en español.

## Convenciones

- Web estática de HTML, CSS y JavaScript para GitHub Pages, sin framework ni compilación. Usa rutas relativas y evita dependencias de un ordenador concreto.
- Reutiliza `css/estilos.css` y `js/render-markdown.js`.
- Cada tutorial tiene `tutoriales/<nombre>/index.html` y `contenido.md`. Al añadir uno, actualiza el catálogo y, cuando corresponda, la portada.
- Carga los módulos de Highlight.js necesarios para los lenguajes de cada guía.
- Conserva las imágenes relativas al Markdown y el enlace de descarga como alternativa si falla JavaScript.

## Preferencias acordadas

- Las instrucciones del bot van dentro de su tarjeta; las propinas, en un bloque propio.
- No muestres «Composable X» ni números redundantes en los títulos de las secciones: el índice ya numera las entradas. Conserva `@Composable` en el código.
- Mantén el botón fijo «↑ Índice», la copia de código y las etiquetas de colores para nivel y requisitos.
- Conserva colores de sintaxis diferenciados y legibles.
- Evita ejercicios genéricos añadidos al final. Conserva las prácticas desarrolladas del autor, como la de Flutter.
- No reescribas el contenido didáctico sin necesidad. Flutter retira los números al renderizar mediante `data-strip-heading-numbers="true"`.
- No inventes límites, disponibilidad ni condiciones de privacidad del bot; su backend no está aquí.

## Verificación y entrega

- Ejecuta `node --check js/render-markdown.js` si modificas JavaScript y `git diff --check`.
- Comprueba las rutas locales y, si hay navegador disponible, escritorio y móvil. Indica qué no se ha verificado.
- No des por probado el bot o Ko-fi por haber comprobado sus enlaces.
- Crea commits o publica cuando el usuario lo solicite. Distingue guardar archivos, commit y push.
- Actualiza la documentación cuando cambien estructura o decisiones relevantes.

## Información pública

Todo lo versionado debe ser apto para publicación. No guardes tokens, contraseñas, datos de alumnos, documentos privados ni transcripciones de conversaciones. Un archivo sin enlaces desde la web no es privado. `.gitignore` no cifra archivos ni controla por sí solo qué se despliega.
