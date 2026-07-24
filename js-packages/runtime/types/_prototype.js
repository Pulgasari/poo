// poo/js-packages/runtime/types/_prototype.js

// :::::: InternL Helpers

function toWords(str) {
  return String(str)
    .replace(/([a-z\d])([A-Z])/g, '$1 $2')
    .replace(/[-_.\s]+/g, ' ')
    .trim()
    .toLowerCase()
    .split(' ')
    .filter(Boolean);
}

// :::::: String

String.prototype.capitalize = function () {
  return this.charAt(0).toUpperCase() + this.slice(1);
};

String.prototype.prefix = function (prefix) {
  return this.startsWith(prefix) ? this : prefix + this;
};

String.prototype.suffix = function (suffix) {
  return this.endsWith(suffix) ? this : this + suffix;
};

String.prototype.unprefix = function (prefix) {
  return this.startsWith(prefix) ? this.slice(prefix.length) : this;
};

String.prototype.unsuffix = function (suffix) {
  return this.endsWith(suffix) ? this.slice(0, -suffix.length) : this;
};


// Umwandlungen zwischen verschiedenen Schreibweisen

String.prototype.isCase = function (name) {
  return this === this.toCase(name);
};

String.prototype.toCase = function (name) {
  return {
    camel    : this.toCamelCase(),
    constant : this.toConstantCase(),
    kebab    : this.toKebabCase(),
    pascal   : this.toPascalCase(),
    snake    : this.toSnakeCase(),
    title    : this.toTitleCase(),
  }[name] ?? this;
};

String.prototype.toCamelCase = function () {
  const words = toWords(this);
  return words.map((word, i) =>
    i === 0 ? word : word[0].toUpperCase() + word.slice(1)
  ).join('');
};

String.prototype.toConstantCase = function () {
  return toWords(this).join('_').toUpperCase();
};

String.prototype.toKebabCase = function () {
  return toWords(this).join('-');
};

String.prototype.toPascalCase = function () {
  return toWords(this).map(word =>
    word[0].toUpperCase() + word.slice(1)
  ).join('');
};

String.prototype.toSnakeCase = function () {
  return toWords(this).join('_');
};

String.prototype.toTitleCase = function () {
  return toWords(this).map(word =>
    word[0].toUpperCase() + word.slice(1)
  ).join(' ');
};

String.prototype.toSlug = function () {
  return this
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, '-')
    .replace(/[^\w-]+/g, '')
    .replace(/--+/g, '-');
};
