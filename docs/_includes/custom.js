let app = {};
app.name     = 'POO';
app.url      = 'https://pulgasari.github.io/poo/';
app.url_repo = 'https://github.com/pulgasari/poo/';

const headerItems = signal([
  { label: 'Docs'    , href: app.url_repo + 'docs/' },
  { label: '@GitHub' , href: app.url_repo           },
]);
function Header () {
  return html`
    <div id='app-header'>
      <div class="menu-brand">${app.name}</div>
      <div class="menu-items">
        ${headerItems.value.map(item => 
          html`<a href="${item.href}">${item.label}</a>`
        )}
      </div>
    </div>
  `;
}

const menuItems = signal([
  { label: 'Start' ,     href: app.url               },
  { label: 'Functions' , href: app.url + 'functions' },
  { label: 'Keywords'  , href: app.url + 'keywords'  },
  { label: 'Objects'   , href: app.url + 'objects'   },
  { label: 'Operators' , href: app.url + 'operators' },
  { label: 'Types'     , href: app.url + 'types'     },
  { label: 'Values'    , href: app.url + 'values'    },
]);
function Menu () {
  return html`
    <div id='app-footer'>
      ${menuItems.value.map(item => 
        html`<a href="${item.href}">${item.label}</a>`
      )}
    </div>
  `;
}

// Ausführung erst, wenn die Seite komplett geladen ist:
window.addEventListener('DOMContentLoaded', () => {
  
  hljs.highlightAll(); // apply syntax highlighting
  patch_md(); // fix the markdown rendering

  const $body     = document.body;
  const tmpHeader = document.createElement('div');
  $body.prepend(tmpHeader);
  render(html`<${Header} />`, tmpHeader);
  tmpHeader.replaceWith(tmpHeader.firstElementChild);
  
  const tmpFooter = document.createElement('div');
  $body.append(tmpFooter);
  render(html`<${Menu} />`, tmpFooter);
  tmpFooter.replaceWith(tmpFooter.firstElementChild);

});
