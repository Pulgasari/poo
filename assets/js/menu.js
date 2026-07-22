// Lade Preact, Signals und HTM von CDN
import { h, render } from 'https://cdn.jsdelivr.net/npm/preact@10.19.3/+esm';
import { signal, computed } from 'https://cdn.jsdelivr.net/npm/@preact/signals-core@1.5.0/+esm';
import htm from 'https://cdn.jsdelivr.net/npm/htm@3.1.1/+esm';

const html = htm.bind(h);

// ------------------------------
// 1. SIGNALS (State)
// ------------------------------
const menuItems = signal([
  { label: 'Home', href: '/' },
  { label: 'Dokumentation', href: '/docs/' },
  { label: 'API', href: '/api/' },
  { label: 'Beispiele', href: '/examples/' },
]);

// Aktuell aktiver Menüpunkt (optional)
const activeIndex = signal(0);

// ------------------------------
// 2. KOMPONENTEN
// ------------------------------

// Menüpunkt-Komponente
function MenuItem({ item, index, active }) {
  return html`
    <a 
      href="${item.href}" 
      class="${active ? 'active' : ''}"
      onClick=${() => { activeIndex.value = index; }}
    >
      ${item.label}
    </a>
  `;
}

// Haupt-Menü-Komponente (oben)
function TopMenu() {
  return html`
    <nav class="sticky-top">
      <div class="menu-container">
        <div class="menu-brand">📘 Mein Projekt</div>
        <div class="menu-items">
          ${menuItems.value.map((item, index) => 
            html`<${MenuItem} key=${index} item=${item} index=${index} active=${index === activeIndex.value} />`
          )}
        </div>
      </div>
    </nav>
  `;
}

// Footer-Menü (unten)
function BottomMenu() {
  return html`
    <nav class="sticky-bottom">
      <div class="menu-container">
        <div class="menu-items">
          ${menuItems.value.map((item) => 
            html`<a href="${item.href}">${item.label}</a>`
          )}
        </div>
        <div class="menu-copyright">
          © ${new Date().getFullYear()} - Mein Projekt
        </div>
      </div>
    </nav>
  `;
}

// ------------------------------
// 3. APP KOMPONENTE (beide Menüs)
// ------------------------------
function App() {
  return html`
    <div id="app">
      <${TopMenu} />
      <main>
        <!-- Der Inhalt deiner README.md wird hier gerendert -->
        <slot />
      </main>
      <${BottomMenu} />
    </div>
  `;
}

// ------------------------------
// 4. RENDER
// ------------------------------
const appContainer = document.createElement('div');
document.body.prepend(appContainer);

render(html`<${App} />`, appContainer);

// ------------------------------
// 5. CSS (werden automatisch eingefügt)
// ------------------------------
const style = document.createElement('style');
style.textContent = `
  /* Sticky Menüs */
  .sticky-top {
    position: sticky;
    top: 0;
    z-index: 1000;
    background: #24292e;
    color: white;
    padding: 12px 20px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }

  .sticky-bottom {
    position: sticky;
    bottom: 0;
    z-index: 1000;
    background: #f6f8fa;
    color: #24292e;
    padding: 12px 20px;
    border-top: 1px solid #d0d7de;
    margin-top: 40px;
  }

  .menu-container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
  }

  .menu-brand {
    font-size: 1.2rem;
    font-weight: bold;
  }

  .menu-items {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
  }

  .menu-items a {
    color: inherit;
    text-decoration: none;
    padding: 6px 12px;
    border-radius: 6px;
    transition: background 0.2s;
  }

  .menu-items a:hover {
    background: rgba(255,255,255,0.1);
  }

  .sticky-bottom .menu-items a {
    color: #24292e;
  }

  .sticky-bottom .menu-items a:hover {
    background: #d0d7de;
  }

  .menu-items a.active {
    background: rgba(255,255,255,0.2);
    font-weight: bold;
  }

  .sticky-bottom .menu-items a.active {
    background: #d0d7de;
  }

  .menu-copyright {
    font-size: 0.9rem;
    opacity: 0.8;
  }

  /* Platz für den Inhalt */
  main {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
  }

  /* README.md wird in main gerendert */
  #app {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }
`;
document.head.appendChild(style);
