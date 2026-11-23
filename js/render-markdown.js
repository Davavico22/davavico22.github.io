(function () {
    const article = document.getElementById('contenido');
    const tocList = document.getElementById('toc-list');
    const source = article?.dataset.source;

    if (!article || !source) {
        return;
    }

    function slugify(text) {
        return text
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/(^-|-$)/g, '');
    }

    function rewriteImagePaths(root) {
        root.querySelectorAll('img').forEach((img) => {
            const src = img.getAttribute('src');
            if (src && !/^(?:[a-z]+:|\/\/|\/|#)/i.test(src)) {
                img.setAttribute('src', new URL(src, new URL(source, document.baseURI)).href);
            }
            img.loading = 'lazy';
            img.decoding = 'async';
        });
    }

    function buildToc(root) {
        if (!tocList) {
            return;
        }

        const headings = [...root.querySelectorAll('h2')];
        const links = headings.map((heading) => {
            const base = slugify(heading.textContent || '') || 'seccion';
            let id = base;
            let suffix = 2;
            while (document.getElementById(id)) id = `${base}-${suffix++}`;
            heading.id = id;
            const item = document.createElement('li');
            const link = document.createElement('a');
            link.href = `#${id}`;
            link.textContent = heading.textContent;
            item.appendChild(link);
            tocList.appendChild(item);
            return link;
        });

        if (!headings.length) return;

        const toc = tocList.closest('.reader-toc');
        if (!toc) return;

        const disclosure = toc.querySelector('details');
        const compact = window.matchMedia('(max-width: 860px)');
        const returnLink = document.querySelector('.back-to-index');
        toc.hidden = false;

        function syncDisclosure() {
            disclosure.open = !compact.matches || location.hash === '#indice';
        }

        syncDisclosure();
        compact.addEventListener('change', syncDisclosure);
        returnLink?.addEventListener('click', () => {
            disclosure.open = true;
        });
        tocList.addEventListener('click', (event) => {
            if (compact.matches && event.target.closest('a')) {
                disclosure.open = false;
            }
        });

        let current = -1;
        let frame = 0;

        function updateCurrent() {
            frame = 0;
            const next = headings.findLastIndex((heading) => heading.getBoundingClientRect().top <= 96);
            if (next === current) return;

            links[current]?.removeAttribute('aria-current');
            links[next]?.setAttribute('aria-current', 'location');
            current = next;
        }

        function scheduleUpdate() {
            if (!frame) frame = window.requestAnimationFrame(updateCurrent);
        }

        window.addEventListener('scroll', scheduleUpdate, { passive: true });
        window.addEventListener('resize', scheduleUpdate);
        article.addEventListener('load', scheduleUpdate, true);
        disclosure.addEventListener('toggle', scheduleUpdate);
        scheduleUpdate();
    }

    fetch(source)
        .then((response) => {
            if (!response.ok) {
                throw new Error('No se pudo cargar el tutorial.');
            }
            return response.text();
        })
        .then((markdown) => {
            marked.setOptions({ gfm: true, breaks: false });
            article.innerHTML = marked.parse(markdown);
            const firstHeading = article.querySelector('h1');
            if (firstHeading) {
                firstHeading.remove();
            }
            rewriteImagePaths(article);
            if (article.dataset.stripHeadingNumbers === 'true') {
                article.querySelectorAll('h2').forEach((heading) => {
                    heading.textContent = heading.textContent.replace(/^\d+[.:]\s+/, '');
                });
            }
            buildToc(article);
            article.querySelectorAll('pre code').forEach((block) => {
                const button = document.createElement('button');
                button.type = 'button';
                button.className = 'copy-button';
                button.textContent = 'Copiar código';
                button.setAttribute('aria-live', 'polite');
                button.addEventListener('click', async () => {
                    try {
                        await navigator.clipboard.writeText(block.textContent);
                        button.textContent = 'Copiado';
                    } catch {
                        button.textContent = 'Selecciona el código para copiarlo';
                    }
                    window.setTimeout(() => { button.textContent = 'Copiar código'; }, 2500);
                });
                block.parentElement.before(button);
                if (window.hljs) {
                    hljs.highlightElement(block);
                }
            });
            article.setAttribute('aria-busy', 'false');
            if (location.hash) {
                document.getElementById(decodeURIComponent(location.hash.slice(1)))?.scrollIntoView();
            }
        })
        .catch(() => {
            article.setAttribute('aria-busy', 'false');
            article.innerHTML = '<p class="error" role="alert">No se ha podido cargar el tutorial. Recarga la página o utiliza el enlace para descargar la guía en Markdown.</p>';
        });
})();
