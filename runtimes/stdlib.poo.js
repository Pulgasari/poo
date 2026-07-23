// only written as js for syntax highlighting
// stdlib/string.poo

// prefix + suffix

fn prefix = (str, prefix) => str.has(prefix) ? str : prefix + str;
fn suffix = (str, suffix) => str.has(suffix) ? str : str + suffix;

fn unprefix = (str, prefix) => str.has(prefix) ? str.slice(prefix.size, str.size) : str;  

// case

fn invert_case (str) {
  val result = "";
  str.loop( fn (char) => {
    val append = char.is_upper_case() ? char.to_lower_case() : char.to_upper_case();   
    result.append(append);
  })
  return result;
}

fn to_kebab_case (str) {
  val words = str.to_words();
  return "-".join(words).to_lower_case();
}

// === 1. inspection & basic getters ===

fn array_first (list) {
  return list.size > 0 ? list[0] : null;
}

fn array_is_empty (list) {
  return list.size == 0;
}

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

    
