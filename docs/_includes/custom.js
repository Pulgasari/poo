import { h, render } from 'https://cdn.jsdelivr.net/npm/preact@10.19.3/+esm';
import { signal }    from 'https://cdn.jsdelivr.net/npm/@preact/signals-core@1.5.0/+esm';
import htm           from 'https://cdn.jsdelivr.net/npm/htm@3.1.1/+esm'; const html = htm.bind(h);
import hljs          from 'https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/+esm';
/*
import { getMetaPropsFromLSD, createHighlightJsObjectFromLSD } from '@cosmonaut/lsd';
const { keywords, literals, builtins, operators, symbols } = getMetaPropsFromLSD(source);
hljs.registerLanguage('poo', function (hljs) { return createHighlightJsObjectFromLSD(source, { name: 'Poo', hljs }); });  
*/

const app = {};
app.name     = 'POO';
app.url      = 'https://pulgasari.github.io/poo/';
app.url_repo = 'https://github.com/pulgasari/poo/';

hljs.registerLanguage('poo', function (hljs) {
  return {
    name: "Poo",
    case_insensitive: false,
    keywords: {
      keyword  : "as|and|break|catch|continue|cpy|do|fail|fn|fn\*|fn\^|if|kill|loop|in|new|obj|or|pkg|ref|return|skip|static|switch|use|val|yield",
      literal  : "false|null|true|undefined",
      built_in : "Array|Blob|Bool|Char|Color|Date|Enum|Generator|List|Map|Number|Queue|Pattern|Record|RegExp|Set|Stack|String|Store|Symbol|Tree|Tuple|Union"
    },
    contains: [
      hljs.COMMENT('//', '$'),
      { className: 'string', begin: '"', end: '"', contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'string', begin: "'", end: "'", contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'string', begin: '`', end: '`', contains: [hljs.BACKSLASH_ESCAPE] },
      { className: 'number', begin: '0[xX][0-9a-fA-F_]+|0[bB][01_]+|\\d[\\d_]*\\.\\d[\\d_]*(?:[eE][+-]?\\d+)?|\\d[\\d_]*' },
      { className: 'operator', begin: '\\?\\?=|~==|===|!==|<=>|>>>|>=<|\\+=|-=|\\*=|/=|#=|~=|==|!=|=<|>=|\\|\\||&&|\\?\\?|>>|\\|\\?|\\|>|\\|\\.|=|<|>|\\+|-|\\*|/|%' }
    ]
  };
});
hljs.highlightAll();
const menuItems = signal([
  { label: 'Home'    , href: app.url           },
  { label: 'Docs'    , href: app.url + 'docs/' },
  { label: '@GitHub' , href: app.url_repo      },
]);

function Menu() {
  return html`
    <nav class="sticky-top">
      <div class="menu-container">
        <div class="menu-brand">${app.name} (preact in docs)</div>
        <div class="menu-items">
          ${menuItems.value.map(item => 
            html`<a href="${item.href}">${item.label}</a>`
          )}
        </div>
      </div>
    </nav>
  `;
}

/*
// Set Theme
const $root = document.documentElement;
$root.dataset.theme = 'dracula';

// Render Preact
const appBody   = document.getElementById('app-body');
const container = document.createElement('div');
appBody.prepend(container);
render(html`<${Menu} />`, container);
*/

// Ausführung erst, wenn die Seite komplett geladen ist:
window.addEventListener('DOMContentLoaded', () => {
  
  // 1. Theme setzen
  document.documentElement.dataset.theme = 'dracula';
  
  // 2. Code-Highlighting anwenden
  hljs.highlightAll();

  // GitHub Alerts ([!NOTE], [!TIP], etc.) automatisch parsen
const alertTypes = {
  note:      { label: 'Note',      color: '#8be9fd' },
  tip:       { label: 'Tip',       color: '#50fa7b' },
  important: { label: 'Important', color: '#bd93f9' },
  warning:   { label: 'Warning',   color: '#f1fa8c' },
  caution:   { label: 'Caution',   color: '#ff79c6' }
};

document.querySelectorAll('blockquote').forEach(bq => {
  const firstP = bq.querySelector('p');
  if (!firstP) return;

  // Prüft, ob der Absatz mit [!NOTE], [!WARNING] etc. beginnt
  const match = firstP.innerHTML.match(/^\[\!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]/i);
  if (match) {
    const key = match[1].toLowerCase();
    const alert = alertTypes[key];

    bq.classList.add('gh-alert', `gh-alert-${key}`);
    
    // Tag [!NOTE] aus dem Text löschen
    firstP.innerHTML = firstP.innerHTML.replace(/^\[\!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]\s*(<br\s*\/?>)?/i, '').trim();

    // Überschrift einfügen
    const titleEl = document.createElement('div');
    titleEl.className = 'gh-alert-title';
    titleEl.textContent = alert.label;
    
    bq.prepend(titleEl);
  }
});


  // 3. Preact Menu oben in die Seite einfügen (Fallback auf document.body)
  const targetElement = document.getElementById('app-body') || document.body;
  const container     = document.createElement('div');
  
  targetElement.prepend(container);
  render(html`<${Menu} />`, container);
  
});
