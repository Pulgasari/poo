// components/Header.js

import Link from './Link.js';

export default function () {
  return html `
    <div id='app-header'>
      POO
      <nav>
        <${Link} href='docs'       label='Docs'       />
        <${Link} href='playground' label='Playground' />
      </nav>
    </div>
  `;
}
