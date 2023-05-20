package spawn_rune

import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rl "vendor:raylib"
import rand "core:math/rand"
import "core:strings"
import "core:slice"
import os "core:os"
import c "core:c"
import mem "core:mem"
import "core:runtime"
import "core:unicode/utf8"
import "core:unicode"
import readdir "../lib/readdir_files"

INTERFACE_RAYLIB :: true
BUFFER_SIZE_OF_EACH_PATH :: 1024
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false
DEBUG_ERRORN :: false
DEBUG_READ_ERRORN :: false
COUNT_TOTAL_PROGRAMS_PATH :: false
TEST_STATEMENT :: false

main_source :: proc() {

  if INTERFACE_RAYLIB {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)

    windown_dim :: n.int2{400, 100}

  }


  m_filter :: proc(
    s: $S/[]$U,
    f: proc(_: U, _: U) -> bool,
    m_v: U,
    allocator := context.allocator,
  ) -> S {
    r := make([dynamic]U, 0, 0, allocator)
    for v in s {
      if f(v, m_v) {
        append(&r, v)
      }
    }
    return r[:]
  }


  keyfor: rl.KeyboardKey
  keyfor = rl.GetKeyPressed()

  // fmt.println ("Hello World")

  hashmap_paths := make(map[string]string)
  defer delete(hashmap_paths)

  enviropment_vars := os.get_env("PATH", context.temp_allocator)

  now_string := ""
  name_binary := ""

  do_readit := true

  counter := 0

  copy_str_now: string
  c_string_now: cstring
  fist_offset: ^cstring
  cstr_name: ^c.char

  count_files: c.int32_t

  total: i32 = 0

  for name in strings.split_after(
    enviropment_vars, // "/home/synbian/rbin", //
    ":",
    context.temp_allocator,
  ) {

    files_arr_ret: ^^c.char

    now_string = strings.trim(name, ":")
    now_string = strings.trim(now_string, " ")

    if os.is_dir_path(now_string) {

      cstr_name =
      cast(^c.char)strings.clone_to_cstring(now_string, context.temp_allocator)

      readdir.creaddir_files(cstr_name, &files_arr_ret, &count_files)

      if DEBUG_PATH {
        fmt.println(" :: ", now_string)
        fmt.println(" : ", count_files, " - ", files_arr_ret)
      }

      for i: i32 = 0; i < count_files; i += 1 {

        fist_offset := cast(^cstring)mem.ptr_offset(files_arr_ret, i)

        c_string_now: cstring = cast(cstring)fist_offset^

        /// try to convert from cstring to string copy it
        // str_now := runtime.cstring_to_string(c_string_now)
        // runtime.copy_from_string(str_now, copy_str_now )

        copy_str_now := strings.clone_from_cstring(
          c_string_now,
          context.temp_allocator,
        )

        //// concatenate path with name string
        // now_string, str_now
        // concated := []string{now_string, copy_str_now}
        // strings.concatenate(concated, context.temp_allocator)
        // fmt.println(concated)

        hashmap_paths[copy_str_now] = now_string
      }

      readdir.free_read_dir(files_arr_ret, count_files)

      if COUNT_TOTAL_PROGRAMS_PATH {
        total += count_files
      }

      count_files = 0
    }
  }

  if COUNT_TOTAL_PROGRAMS_PATH {
    fmt.println("total :: ", total)
  }

  /*
  for i, k in hashmap_paths {
    fmt.println(i)
    fmt.println(k)

  } */

  keys_global, err := slice.map_keys(hashmap_paths, context.temp_allocator)


  filter_up :: proc(key_hash: string, m_value_of_now: string) -> bool {
    if strings.has_prefix(key_hash, m_value_of_now) {
      return true
    } else {
      return false
    }
  }

  filter_sort :: proc() {

  }

  filter_enviropment :: proc(
    search_for: string,
    keys_global: []string,
    hashmap: ^map[string]string,
  ) -> string {

    filtered := m_filter(
      keys_global,
      filter_up,
      search_for,
      context.temp_allocator,
    )

    fmt.println(filtered)

    if len(filtered) > 0 {
      thing := slice.first(filtered)

      jj := []string{hashmap[thing], thing}

      joined, err_e := strings.join_safe(jj, "/", context.temp_allocator)
      fmt.println(joined)
      return joined
    } else {

      fmt.println("not found")
      return ""
    }
  }


  // os.execvp("/usr/bin/caja &", params)

  if INTERFACE_RAYLIB {
    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    current_speed: f32 = 6.0
    old_current_speed: f32 = current_speed

    pause: bool = false

    fmt.println("counter :: ", counter)

    runner_simbol: string = ""

    word: string = ""

    rune_one_caracter: rune
    runes_swaps: []rune
    swap_str_arr: []string
    str_temp: string

    for is_running && rl.WindowShouldClose() == false {

      rl.DrawText("Hello World!", 10, 10, 20, rl.DARKGRAY)
      /*scores: cstring = strings.clone_to_cstring(
            fmt.tprintf("hello world",  context.temp_allocator,
        )*/

      // rl.DrawText(string(windown_dim.x), 0, 0, 20, rl.DARKGRAY)
      // rl.DrawText(string(windown_dim.y), 0, 10, 20, rl.DARKGRAY)

      color_now := rl.RED

      /// handle game play velocity
      keyfor = rl.GetKeyPressed()
      if keyfor == rl.KeyboardKey.ENTER {
        color_now = rl.BLUE

        if runner_simbol != "" {
          os.execvp(runner_simbol, []string{})
        }
      } else if (keyfor >= rl.KeyboardKey.A) && (keyfor <= rl.KeyboardKey.Z) {

        rune_one_caracter = cast(rune)(keyfor)
        rune_one_caracter = unicode.to_lower(rune_one_caracter)
        runes_swaps = []rune{rune_one_caracter}

        str_temp = utf8.runes_to_string(runes_swaps)

        swap_str_arr = []string{word, str_temp}

        word = strings.concatenate(swap_str_arr)

        if DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol = filter_enviropment(word, keys_global, &hashmap_paths)

      } else if keyfor == rl.KeyboardKey.BACKSPACE {

        if len(word) == 1 {
          word = ""
        } else {

          word = strings.cut(word, 0, len(word) - 1, context.temp_allocator)
        }

        if DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol = filter_enviropment(word, keys_global, &hashmap_paths)
      } else if keyfor == rl.KeyboardKey.SPACE {

        swap_str_arr = []string{word, " "}

        word = strings.concatenate(swap_str_arr)

        if DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol = filter_enviropment(word, keys_global, &hashmap_paths)
      }


      rl.DrawRectangle(0, 0, 30, 30, color_now)

      rl.ClearBackground(rl.WHITE)

      rl.DrawText("Spawn Rune", 100, 100, 20, rl.DARKGRAY)

      rl.EndDrawing()
    }
  }
}

main_test_fail :: proc() {

  counter := 0

  name_binary, now_string: string = "", ""

  fd, err := os.open("/bin", os.O_RDONLY, 0)
  files_info, ok := os.read_dir(fd, BUFFER_SIZE_OF_EACH_PATH)
  if ok == 0 {
    if DEBUG_READ_ERRORN {
      fmt.println("ERROR READ ::: |", now_string, "|")
    }
  }

  if len(files_info) != 0 {

    for binary in files_info {

      // fmt.print (now_string," - ")
      name_binary = strings.cut(
        binary.fullpath,
        strings.last_index(binary.fullpath, "/"),
        0,
        context.temp_allocator,
      )

      counter += 1

      if DEBUG_PATH {
        name_binary = strings.trim_left(name_binary, "/")
        fmt.print(name_binary)
        fmt.print(" - ")
        fmt.println(binary.fullpath)
      }

    }
  }

  fmt.println(counter)

}

main :: proc() {

  // main_proc() // still not working propely

  main_source()
}
