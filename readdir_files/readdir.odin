package creaddir

import "core:c"

when ODIN_OS == .Linux   do foreign import creaddir "creaddir_files.a"

foreign creaddir {
	creaddir_files :: proc(name : ^c.char, files_names : ^^^c.char, size : ^c.int)    -> c.int ---
}
