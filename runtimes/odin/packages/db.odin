package db

import "core:c"
import "core:strings"
import "../../types"

// === 1. external c sqlite3 links ===

foreign import sqlite3 "system:sqlite3"

Sqlite3_Ctx  :: struct{}
Sqlite3_Stmt :: struct{}

foreign sqlite3 {
  sqlite3_close        :: proc(db: ^Sqlite3_Ctx) -> c.int ---
  sqlite3_column_count :: proc(stmt: ^Sqlite3_Stmt) -> c.int ---
  sqlite3_column_name  :: proc(stmt: ^Sqlite3_Stmt, col: c.int) -> cstring ---
  sqlite3_column_text  :: proc(stmt: ^Sqlite3_Stmt, col: c.int) -> cstring ---
  sqlite3_finalize     :: proc(stmt: ^Sqlite3_Stmt) -> c.int ---
  sqlite3_open         :: proc(filename: cstring, ppDb: ^^Sqlite3_Ctx) -> c.int ---
  sqlite3_prepare_v2   :: proc(db: ^Sqlite3_Ctx, zSql: cstring, nByte: c.int, ppStmt: ^^Sqlite3_Stmt, pzTail: ^cstring) -> c.int ---
  sqlite3_step         :: proc(stmt: ^Sqlite3_Stmt) -> c.int ---
}

// === 2. c status constants ===

SQLITE_DONE :: 101
SQLITE_OK   :: 0
SQLITE_ROW  :: 100

// === 3. package global state ===

internal_db : ^Sqlite3_Ctx = nil

// === 4. core database operations ===

// executes a command without data returns like inserts or updates
execute :: proc (sql_str: string) -> bool {
  ensure_opened()
  if (internal_db == nil) { return false }

  stmt : ^Sqlite3_Stmt = nil
  c_sql := strings.clone_to_cstring(sql_str, context.temp_allocator)

  if (sqlite3_prepare_v2(internal_db, c_sql, -1, &stmt, nil) != SQLITE_OK) { return false }
  defer sqlite3_finalize(stmt)

  if (sqlite3_step(stmt) != SQLITE_DONE) { return false }
  return true
}

// queries rows and maps records into a POO native array collection
query :: proc (sql_str: string, allocator := context.allocator) -> ^types.Array {
  ensure_opened()
  if (internal_db == nil) { return nil }

  stmt : ^Sqlite3_Stmt = nil
  c_sql := strings.clone_to_cstring(sql_str, context.temp_allocator)

  if (sqlite3_prepare_v2(internal_db, c_sql, -1, &stmt, nil) != SQLITE_OK) { return nil }
  defer sqlite3_finalize(stmt)

  result_array := new(types.Array, allocator)
  result_array.items = make([dynamic]types.Value, allocator)

  // loop over all returned sql rows matching data footprints
  for sqlite3_step(stmt) == SQLITE_ROW {
    row_map := new(types.Map, allocator)
    row_map.entries = make(map[string]types.Value, allocator)
    cols := sqlite3_column_count(stmt)

    for i : c.int = 0; i < cols; i += 1 {
      name := string(sqlite3_column_name(stmt, i))
      text := string(sqlite3_column_text(stmt, i))
      
      // string clones prevent reference garbage data inside virtual buffers
      allocated_text := strings.clone(text, allocator)
      row_map.entries[name] = types.Value(allocated_text)
    }

    append(&result_array.items, types.Value(row_map))
  }

  return result_array
}

// === 5. lifecycle helpers ===

// safely terminates global database instances on close routines
close_database :: proc () {
  if (internal_db == nil) { return }
  sqlite3_close(internal_db)
  internal_db = nil
}

// guarantees safe connection instances targeting standard files
ensure_opened :: proc () {
  if (internal_db != nil) { return }
  sqlite3_open("poo.db", &internal_db)
}
