let app = {};
app.name     = 'POO';
app.url      = 'https://pulgasari.github.io/poo/docs/';
app.url_repo = 'https://github.com/pulgasari/poo/';

const headerItems = signal([
  { label: 'Playground' , href: 'https://pulgasari.github.io/poo/playground/' },
  { label: '@Discord'   , href: app.url      },
  { label: '@GitHub'    , href: app.url_repo },
]);
function Header () {
  return html`
    <div id='app-header'>
      <div class="brand">${app.name}</div>
      <div class="menu">
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
  const currentUrl = window.location.href.replace(/\/$/, '');
  const    rootUrl = app.url.replace(/\/$/, '');

  return html`
    <div id='app-footer'>
      ${menuItems.value.map(item => {
        const itemUrl    = item.href.replace(/\/$/, '');
        const isCurrent  = currentUrl === itemUrl;
        const isParent   = !isCurrent && itemUrl !== rootUrl && currentUrl.startsWith(itemUrl + '/');
        const classNames = [ isCurrent ? 'is-current' : '', isParent  ? 'is-parent'  : '' ].filter(Boolean).join(' ');
        return html`<a href="${item.href}" class="${classNames}">${item.label}</a>`;
      })}
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
