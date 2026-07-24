// only written as js for syntax highlighting
// stdlib/string.poo

fn bytesize = str => str.bytesize; // gets inlined by compiler
fn is_empty = str => str.size === 0;
fn size     = str => str.size; // gets inlined by compiler
fn trim     = str => str.trim_space();

fn slice = (str, start, end) => str.substring(start, end);

fn to_morph (str, callback) => morph(str, callback);

fn has (str, needle) => str.contains(needle);

fn join = (delimiter, collection) => collection.join(delimiter);

fn replace = (str, target, replacement) => str.replace_all(target, replacement);

// prefix + suffix

fn prefix = (str, prefix) => str.has(prefix) ? str : prefix + str;
fn suffix = (str, suffix) => str.has(suffix) ? str : str + suffix;

fn unprefix = (str, prefix) => str.has(prefix) ? str.slice(    prefix.size, str.size) : str;  
fn unsuffix = (str, suffix) => str.has(suffix) ? str.slice(0, str.size - suffix.size) : str;        


// case

fn invert_case (str) {
  val result = "";
  str.loop( fn (char) => {
    val append = char.is_upper_case() ? char.to_lower_case() : char.to_upper_case();   
    result.append(append);
  })
  return result;
}



fn string_is_case (str, case) {
  switch (case) {
    :camel   => str === str.to_camel_case();
    :kebab   => str === str.to_kebab_case();
    :lower   => str === str.to_lower_case();
    :pascal  => str === str.to_pascal_case();
    :snake   => str === str.to_snake_case();
    :upper   => str === str.to_upper_case();
    or => false
  }
}

fn is_case = (str, case) => str === str.to_case(case);


fn string_to_case (str, case) {
  switch (case) {
    'camel'    => str.to_camel_case();
    'constant' => str.to_constant_case();
    'kebab'    => str.to_kebab_case();
    'lower'    => str.to_lower_case();
    'pascal'   => str.to_pascal_case();
    'snake'    => str.to_snake_case();
    'title'    => str.to_title_case();
    'upper'    => str.to_upper_case();
    or         => str;
  }
}

fn string_invert_case (str) {
  val result = "";
  str.loop(fn (char) => {
    val append_char = char.is_upper_case() ? char.to_lower_case() : char.to_upper_case();
    result.append(append_char);
  });
  return result;
}

fn string_loop (str, callback) {
  val len = str.size;
  loop (val i = 0; i < len; i += 1) {
    callback(str[i], i);
  }
  return str;
}

fn morph = (str, callback) => '' >>> loop (str as char, i) do @ += callback(char, i);

fn string_to_camel_case (str) {
  val words = str.to_words();
  val result = "";
  words.loop(fn (word, i) => {
    val formatted = i == 0 ? word.to_lower_case() : word.to_pascal_case();
    result.append(formatted);
  });
  return result;
}



fn    to_constant_case = str => '_'.join( words |> @.to_words ).to_upper_case();
fn        to_flat_case = str =>  ''.join( words |> @.to_words ).to_lower_case();
fn       to_kebab_case = str => '-'.join( words |> @.to_words ).to_lower_case();
fn        to_slug_case = str => '-'.join( words |> @.to_words ).to_lower_case();
fn       to_snake_case = str => '_'.join( words |> @.to_words ).to_lower_case();
fn to_upper_kebab_case = str => '-'.join( words |> @.to_words ).to_lower_case();

fn string_to_mocking_case (str) {
  val result = "";
  str.loop(fn (char, i) => {
    val formatted = i % 2 == 0 ? char.to_lower_case() : char.to_upper_case();
    result.append(formatted);
  });
  return result;
}

fn string_to_pascal_case (str) {
  val words = str.to_words();
  val result = "";
  words.loop(fn (word) => {
    if (word.size > 0) {
      val first = word.slice(0, 1).to_upper_case();
      val rest  = word.slice(1, word.size).to_lower_case();
      result.append(first + rest);
    }
  });
  return result;
}



fn string_to_title_case (str) {
  val words = str.to_words();
  val capitalized = words.map(fn (w) => w.slice(0, 1).to_upper_case() + w.slice(1, w.size).to_lower_case());
  return " ".join(capitalized);
}


// === 5. splitting, joining & helpers ===



fn string_slugify (str, options = #{ separator: "-" }) {
  val sep = options.separator ? options.separator : "-";
  val words = str.to_words();
  return sep.join(words).to_lower_case();
}

fn string_switch_case (str, ...cases) {
  val current_idx = -1;
  cases.loop(fn (c, i) => {
    if (str.is_case(c)) { current_idx = i; }
  });
  val next_idx = (current_idx + 1) % cases.size;
  return str.to_case(cases[next_idx]);
}





// ////// ARRAY

// === 1. inspection & basic getters ===

fn array_first    = list => list.size > 0 ? list[0] : null;
fn array_is_empty = list => list.size == 0;

fn array_last (list) {
  val size = list.size;
  return size > 0 ? list[size - 1] : null;
}

// === 2. iteration & functional transformations ===

fn array_every (list, predicate) {
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    if (!predicate(list[i], i)) { return false; }
  }
  return true;
}

fn array_filter (list, predicate) {
  val result = [];
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    val item = list[i];
    if (predicate(item, i)) {
      result.append(item);
    }
  }
  return result;
}

fn array_find (list, predicate) {
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    val item = list[i];
    if (predicate(item, i)) { return item; }
  }
  return null;
}

fn array_find_index (list, predicate) {
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    if (predicate(list[i], i)) { return i; }
  }
  return -1;
}

fn array_flat (list) {
  val result = [];
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    val item = list[i];
    if (item.is_array) {
      val inner_flat = array_flat(item);
      loop (val j = 0; j < inner_flat.size; j += 1) {
        result.append(inner_flat[j]);
      }
    } or {
      result.append(item);
    }
  }
  return result;
}

fn array_has (list, target) {
  loop (0..list.size) {
    if (list[i] == target) { return true; }
  }
  return false;
}

fn arry_loop (list, callback) {
  loop (0 as i < list.size) do callback(list[i], i) or return list ?? [];
}

fn array_map (list, callback) {
  val result = [];
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    result.append(callback(list[i], i));
  }
  return result;
}

fn array_reduce (list, callback, initial) {
  val acc = initial;
  val start_idx = 0;
  
  if (acc == null && list.size > 0) {
    acc = list[0];
    start_idx = 1;
  }

  val len = list.size;
  loop (val i = start_idx; i < len; i += 1) {
    acc = callback(acc, list[i], i);
  }
  return acc;
}

fn array_some (list, predicate) {
  val len = list.size;
  loop (val i = 0; i < len; i += 1) {
    if (predicate(list[i], i)) { return true; }
  }
  return false;
}

// === 3. ordering & string integration ===

fn array_join (list, delimiter = ", ") {
  val result = "";
  val len    = list.size;
  loop (val i = 0; i < len; i += 1) {
    result.append(list[i].to_string());
    if (i < len - 1) {
      result.append(delimiter);
    }
  }
  return result;
}

fn array_reverse (list) {
  val result = [];
  val len = list.size;
  loop (val i = len - 1; i >= 0; i -= 1) {
    result.append(list[i]);
  }
  return result;
}

    
