package readdir

import "core:c"

when ODIN_OS == .Linux do foreign import creaddir "../creaddir_files.a"

MAX_CREADDIR_FILE_NAME :: 64

foreign creaddir {

  creaddir_files :: proc(name: ^c.char, files_names: ^^^c.char, size: ^c.int) -> c.int ---
  creaddir_files_linear :: proc(name: ^c.char, files_names: ^^c.char, size: ^c.int) -> c.int ---

  free_read_dir :: proc(files_names_ret: ^^c.char, size: i32) -> c.int ---
  free_read_dir_linear :: proc(files_names_ret: ^c.char, size: i32) -> c.int ---

  debug_read_dir_files :: proc(files_names_ret: ^^c.char, size: i32) -> c.int ---
}
