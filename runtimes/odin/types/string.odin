package types

import "core:strings"
import "core:unicode/utf8"

// === 1. primitive inspection & conversion ===

string_byte_len :: proc (s: string) -> int { return len(s) }

string_char_at :: proc (s: string, idx: int) -> Value {
  if (idx < 0 || len(s) == 0) { return Value(Null{}) }

  curr_idx := 0
  for r in s {
    if (curr_idx == idx) { return Value(Char(r)) }
    curr_idx += 1
  }

  return Value(Null{})
}

string_char_len :: proc (s: string) -> int {
  return utf8.rune_count_in_string(s)
}

string_is_empty :: proc (s: string) -> bool { return len(s) == 0 }

// === 2. string allocation & manipulation ===

string_clone :: proc (s: string, allocator := context.allocator) -> string {
  if (len(s) == 0) { return "" }
  return strings.clone(s, allocator)
}

string_concat :: proc (a: string, b: string, allocator := context.allocator) -> string {
  if (len(a) == 0) { return b }
  if (len(b) == 0) { return a }
  return strings.concatenate({a, b}, allocator)
}

string_substring :: proc (s: string, start: int, end: int, allocator := context.allocator) -> string {
  r_count := utf8.rune_count_in_string(s)
  if (start < 0 || start >= r_count || end <= start) { return "" }

  real_end := end
  if (real_end > r_count) { real_end = r_count }

  byte_end := len(s)
  byte_start := 0
  curr_idx := 0

  for _, offset in s {
    if (curr_idx == start) { byte_start = offset }
    if (curr_idx == real_end) { byte_end = offset; break }
    curr_idx += 1
  }

  return strings.clone(s[byte_start:byte_end], allocator)
}

// === 3. comparison & matching primitives ===

string_contains :: proc (haystack: string, needle: string) -> bool {
  if (len(needle) == 0) { return true }
  return strings.contains(haystack, needle)
}

string_equals :: proc (a: string, b: string) -> bool {
  return a == b
}

string_has_prefix :: proc (s: string, prefix: string) -> bool {
  return strings.has_prefix(s, prefix)
}

string_has_suffix :: proc (s: string, suffix: string) -> bool {
  return strings.has_suffix(s, suffix)
}




// === 1. primitive inspection & metrics ===

string_byte_len :: proc (s: string) -> int { return len(s) }

string_char_at :: proc (s: string, idx: int) -> Value {
  if (idx < 0 || len(s) == 0) { return Value(Null{}) }

  curr_idx := 0
  for r in s {
    if (curr_idx == idx) { return Value(Char(r)) }
    curr_idx += 1
  }

  return Value(Null{})
}

string_char_len :: proc (s: string) -> int {
  return utf8.rune_count_in_string(s)
}

string_is_empty :: proc (s: string) -> bool { return len(s) == 0 }

// === 2. allocation & manipulation primitives ===

string_clone :: proc (s: string, allocator := context.allocator) -> string {
  if (len(s) == 0) { return "" }
  return strings.clone(s, allocator)
}

string_concat :: proc (a: string, b: string, allocator := context.allocator) -> string {
  if (len(a) == 0) { return b }
  if (len(b) == 0) { return a }
  return strings.concatenate({a, b}, allocator)
}

string_replace_all :: proc (s: string, old_str: string, new_str: string, allocator := context.allocator) -> string {
  if (len(s) == 0 || len(old_str) == 0) { return s }
  res, _ := strings.replace_all(s, old_str, new_str, allocator)
  return res
}

string_substring :: proc (s: string, start: int, end: int, allocator := context.allocator) -> string {
  r_count := utf8.rune_count_in_string(s)
  if (start < 0 || start >= r_count || end <= start) { return "" }

  real_end := end
  if (real_end > r_count) { real_end = r_count }

  byte_end := len(s)
  byte_start := 0
  curr_idx := 0

  for _, offset in s {
    if (curr_idx == start) { byte_start = offset }
    if (curr_idx == real_end) { byte_end = offset; break }
    curr_idx += 1
  }

  return strings.clone(s[byte_start:byte_end], allocator)
}

string_to_lower :: proc (s: string, allocator := context.allocator) -> string {
  return strings.to_lower(s, allocator)
}

string_to_upper :: proc (s: string, allocator := context.allocator) -> string {
  return strings.to_upper(s, allocator)
}

string_trim_space :: proc (s: string, allocator := context.allocator) -> string {
  return strings.clone(strings.trim_space(s), allocator)
}

// === 3. comparison & matching primitives ===

string_contains :: proc (haystack: string, needle: string) -> bool {
  if (len(needle) == 0) { return true }
  return strings.contains(haystack, needle)
}

string_equals :: proc (a: string, b: string) -> bool {
  return a == b
}

string_has_prefix :: proc (s: string, prefix: string) -> bool {
  return strings.has_prefix(s, prefix)
}

string_has_suffix :: proc (s: string, suffix: string) -> bool {
  return strings.has_suffix(s, suffix)
}
