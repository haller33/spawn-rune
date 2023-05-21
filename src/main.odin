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
import "core:sort"
import readdir "../lib/readdir_files"

BUFFER_SIZE_OF_EACH_PATH :: 1024

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: true
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false
DEBUG_READ_ERRORN :: false
COUNT_TOTAL_PROGRAMS_PATH :: false
TEST_STATEMENT :: false

main_source :: proc() {


  windown_dim :: n.int2{400, 100}

  when INTERFACE_RAYLIB {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)
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

  hashmap_paths := make(map[string]string, 11264, context.temp_allocator)
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

      when DEBUG_PATH {
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

      when COUNT_TOTAL_PROGRAMS_PATH {
        total += count_files
      }

      count_files = 0
    }
  }

  when COUNT_TOTAL_PROGRAMS_PATH {
    fmt.println("total :: ", total)
  }


  keys_global, err := slice.map_keys(hashmap_paths, context.temp_allocator)

  not_found_by_search: bool = false


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
  ) -> (
    path: string,
    not_found_by_search: bool,
  ) {

    filtered := m_filter(
      keys_global,
      filter_up,
      search_for,
      context.temp_allocator,
    )

    lenof := len(filtered)

    if lenof == 1 {

      thing := slice.first(filtered)

      jj := []string{hashmap[thing], thing}

      joined, err_e := strings.join_safe(jj, "/", context.temp_allocator)
      fmt.println(joined)

      return joined, true
    } else if lenof > 0 {

      /// there is no much files
      /// so because on 76% of time of search, this feels more rapid
      /// need to be check
      slice.sort(filtered)

      /// the majority of time is sloww
      // sort.bubble_sort(filtered)

      fmt.println(filtered)

      thing := slice.first(filtered)

      jj := []string{hashmap[thing], thing}

      joined, err_e := strings.join_safe(jj, "/", context.temp_allocator)
      fmt.println(joined)
      return joined, true
    } else {

      fmt.println("not found")
      return "", false
    }
  }


  // os.execvp("/usr/bin/caja &", params)

  when INTERFACE_RAYLIB {
    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    current_speed: f32 = 6.0
    old_current_speed: f32 = current_speed

    pause: bool = false

    fmt.println("counter :: ", counter)

    runner_simbol: string = ""

    word: string = ""

    temp_word: cstring
    rune_one_caracter: rune
    runes_swaps: []rune
    swap_str_arr: []string
    str_temp: string

    for is_running && rl.WindowShouldClose() == false {

      // rl.DrawText("Hello World!", 10, 10, 20, rl.DARKGRAY)
      /*scores: cstring = strings.clone_to_cstring(
            fmt.tprintf("hello world",  context.temp_allocator,
        )*/

      // rl.DrawText(string(windown_dim.x), 0, 0, 20, rl.DARKGRAY)
      // rl.DrawText(string(windown_dim.y), 0, 10, 20, rl.DARKGRAY)

      /// handle game play velocity
      keyfor = rl.GetKeyPressed()
      if keyfor == rl.KeyboardKey.ENTER {

        if runner_simbol != "" {
          os.execvp(runner_simbol, []string{})
        }
      } else if (keyfor >= rl.KeyboardKey.A) && (keyfor <= rl.KeyboardKey.Z) {

        rune_one_caracter = cast(rune)(keyfor)
        rune_one_caracter = unicode.to_lower(rune_one_caracter)
        runes_swaps = []rune{rune_one_caracter}

        str_temp = utf8.runes_to_string(runes_swaps, context.temp_allocator)

        swap_str_arr = []string{word, str_temp}

        word = strings.concatenate(swap_str_arr, context.temp_allocator)

        when DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol, not_found_by_search = filter_enviropment(
          word,
          keys_global,
          &hashmap_paths,
        )

      } else if keyfor == rl.KeyboardKey.BACKSPACE {

        if len(word) == 1 {
          word = ""
          runner_simbol = ""
        } else {

          word = strings.cut(word, 0, len(word) - 1, context.temp_allocator)
        }

        when DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol, not_found_by_search = filter_enviropment(
          word,
          keys_global,
          &hashmap_paths,
        )
      } else if keyfor == rl.KeyboardKey.SPACE {

        swap_str_arr = []string{word, " "}

        word = strings.concatenate(swap_str_arr, context.temp_allocator)

        when DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol, not_found_by_search = filter_enviropment(
          word,
          keys_global,
          &hashmap_paths,
        )
      } else if keyfor == rl.KeyboardKey.PERIOD {

        swap_str_arr = []string{word, "."}

        word = strings.concatenate(swap_str_arr, context.temp_allocator)

        when DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol, not_found_by_search = filter_enviropment(
          word,
          keys_global,
          &hashmap_paths,
        )
      } else if (keyfor == rl.KeyboardKey.MINUS) ||
         (keyfor == rl.KeyboardKey.KP_SUBTRACT) {

        swap_str_arr = []string{word, "-"}

        word = strings.concatenate(swap_str_arr, context.temp_allocator)

        when DEBUG_INTERFACE_WORD {fmt.println(word)}

        runner_simbol, not_found_by_search = filter_enviropment(
          word,
          keys_global,
          &hashmap_paths,
        )
      } else if keyfor == rl.KeyboardKey.TAB {

        /// TODOOOOOOO : add rotate on list of results for search of now
      }

      temp_word = strings.unsafe_string_to_cstring(word)

      rl.ClearBackground(rl.WHITE)

      rl.DrawText("Spawn Rune", 100, 100, 20, rl.DARKGRAY)

      rl.DrawText(
        temp_word,
        (windown_dim.x / 2) - 20,
        (windown_dim.y / 2) - 20,
        20,
        rl.DARKGRAY,
      )

      if not_found_by_search {

        rl.DrawText(
          "not found",
          (windown_dim.x / 2) - 20,
          (windown_dim.y / 2) - 40,
          20,
          rl.RED,
        )
      }

      rl.EndDrawing()
    }
  }
}

when !TEST_MODE {
  main_test_fail :: proc() {

    counter := 0

    name_binary, now_string: string = "", ""

    fd, err := os.open("/bin", os.O_RDONLY, 0)
    files_info, ok := os.read_dir(fd, BUFFER_SIZE_OF_EACH_PATH)
    if ok == 0 {
      when DEBUG_READ_ERRORN {
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

        when DEBUG_PATH {
          name_binary = strings.trim_left(name_binary, "/")
          fmt.print(name_binary)
          fmt.print(" - ")
          fmt.println(binary.fullpath)
        }

      }
    }

    fmt.println(counter)

  }
}

main_scheduler :: proc() {

  // put LUA stuff here

  // main_proc() // still not working propely

  main_source()
}

main :: proc() {

  when SHOW_LEAK {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
  }

  when !TEST_MODE {
    main_scheduler()
  } else {
    testing()
  }

  when SHOW_LEAK {
    for _, leak in track.allocation_map {
      fmt.printf("%v leaked %v bytes\n", leak.location, leak.size)
    }
    for bad_free in track.bad_free_array {
      fmt.printf(
        "%v allocation %p was freed badly\n",
        bad_free.location,
        bad_free.memory,
      )
    }
  }
  return
}
