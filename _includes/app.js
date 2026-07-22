import { h, render } from 'https://cdn.jsdelivr.net/npm/preact@10.19.3/+esm';
import { signal } from 'https://cdn.jsdelivr.net/npm/@preact/signals-core@1.5.0/+esm';
import htm from 'https://cdn.jsdelivr.net/npm/htm@3.1.1/+esm';

const html = htm.bind(h);
alert('moin from layouts !!!');

// Menü-Links aus dem HTML auslesen (oder fest definieren)
const links = document.querySelectorAll('.menu-items a');
const menuItems = signal(
    Array.from(links).map(link => ({
        label: link.textContent,
        path: link.getAttribute('data-path'),
        href: link.getAttribute('href')
    }))
);

// Aktiven Pfad ermitteln
const currentPath = signal(window.location.pathname.replace('/reponame', '') || '/');

// Menü-Komponente (optional: für reaktive Updates)
function Menu() {
    return html`
        <nav class="sticky-top">
            <div class="menu-container">
                <div class="menu-brand">📘 Mein Projekt</div>
                <div class="menu-items">
                    ${menuItems.value.map(item => 
                        html`
                            <a 
                                href="${item.href}" 
                                data-path="${item.path}"
                                class="${currentPath.value === item.path ? 'active' : ''}"
                            >
                                ${item.label}
                            </a>
                        `
                    )}
                </div>
            </div>
        </nav>
    `;
}

// Optional: Render nur für reaktive Updates
// render(html`<${Menu} />`, document.querySelector('.menu-container').parentElement);
