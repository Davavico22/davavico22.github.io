# Web de David Valdivia Vico

Web personal y educativa estática para GitHub Pages. Dominio configurado en `CNAME`: **davavico.es**. Incluye un bot de Telegram para convertir documentos a Markdown, apoyo mediante Ko-fi y tutoriales de Jetpack Compose y Flutter.

## Continuar desde otro ordenador

1. Clona el repositorio y abre su carpeta en tu editor o agente.
2. Lee `AGENTS.md` y `docs/CONTEXTO.md` para conocer las convenciones y decisiones.
3. Revisa `git status --short` y `git log -5 --oneline` para conocer el estado real.
4. Previsualiza con un servidor HTTP: abrir los HTML mediante `file://` puede impedir que se carguen los tutoriales con `fetch`.

Con Python instalado:

```sh
python -m http.server 8000
```

Abre `http://localhost:8000`. No necesitas instalar dependencias del proyecto. Las bibliotecas de los tutoriales se cargan desde un CDN y requieren internet.

## Estructura

| Ruta | Función |
| --- | --- |
| `index.html` | Portada, bot, catálogo y Ko-fi |
| `css/estilos.css` | Estilos compartidos y colores de código |
| `js/render-markdown.js` | Markdown, índice, imágenes, resaltado y copia de código |
| `tutoriales/index.html` | Catálogo |
| `tutoriales/compose-componentes/` | Página, Markdown e imágenes de Compose |
| `tutoriales/flutter-componentes/` | Página y Markdown de Flutter |
| `CNAME` y `.nojekyll` | Dominio y publicación sin Jekyll |
| `AGENTS.md` | Instrucciones para agentes |
| `docs/CONTEXTO.md` | Arquitectura, decisiones y mantenimiento |

## Validación

```sh
node --check js/render-markdown.js
git diff --check
```

Comprueba también navegación, imágenes, código, índice, descarga de Markdown y móvil. Node solo se necesita para comprobar la sintaxis, no para servir la web.

## Publicación y documentación

Consulta la rama y carpeta de publicación en GitHub → Settings → Pages. Esa configuración no está declarada en los archivos actuales. Un commit local no publica la web por sí solo.

La documentación está redactada para ser pública. No contiene credenciales ni contexto privado. Los Markdown de los tutoriales son parte de la web: el navegador los descarga para mostrar las guías.
