// components/Link.js

export default function ({ href, label, children }) {
  return html `<a href=${href}>${children || label}</a>`;
}
