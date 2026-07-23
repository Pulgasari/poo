// only written as js for syntax highlighting
// stdlib/string.poo

fn string_prefix (str, prefix, separator = "") {
  return str.has(prefix) ? str : prefix + separator + str;
}

fn string_unprefix (str, prefix) {
  return str.has(prefix) ? str.slice(prefix.size, str.size) : str;
}

fn string_invert_case (str) {
  val result = "";
  str.loop( fn (char) => {
    val append = char.is_upper_case() ? char.to_lower_case() : char.to_upper_case();   
    result.append(append);
  })
  return result;
}

fn string_to_kebab_case (str) {
  val words = str.to_words();
  return "-".join(words).to_lower_case();
}
