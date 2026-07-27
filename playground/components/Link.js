// components/Link.js

const base = 'https://pulgasari.github.io/poo/';

export default function ({ href, label, children }) {
  href = href.startsWith('https://') ? href : (base + href);
  
  return html `<a href=${href}>${children || label}</a>`;
}
