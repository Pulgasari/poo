// menu.js - NUR das Menü, ohne App-Wrapper
import { h, render } from 'https://cdn.jsdelivr.net/npm/preact@10.19.3/+esm';
import { signal } from 'https://cdn.jsdelivr.net/npm/@preact/signals-core@1.5.0/+esm';
import htm from 'https://cdn.jsdelivr.net/npm/htm@3.1.1/+esm';

const html = htm.bind(h);

const menuItems = signal([
  { label: 'Home', href: '/' },
  { label: 'Docs', href: '/docs/' },
  { label: 'API', href: '/api/' },
]);

function Menu() {
  return html`
    <nav class="sticky-top">
      <div class="menu-container">
        <div class="menu-brand">📘 Mein Projekt</div>
        <div class="menu-items">
          ${menuItems.value.map(item => 
            html`<a href="${item.href}">${item.label}</a>`
          )}
        </div>
      </div>
    </nav>
  `;
}

const container = document.createElement('div');
document.body.prepend(container);
render(html`<${Menu} />`, container);

// CSS (wie gehabt)
const style = document.createElement('style');
style.textContent = `body { background: yellow;} `;
document.head.appendChild(style);
