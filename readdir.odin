package creadddir

import "core:c"

when ODIN_OS == .Linux   do foreign import creaddir "creaddir.a"

foreign creaddir {
	creaddir :: proc(name : ^c.char, files_names : ^^^c.char, size : ^c.int)    -> c.int ---
}
