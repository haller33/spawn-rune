package spawn_rune

import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rl "vendor:raylib"
import rand "core:math/rand"
import "core:strings"
import os "core:os"
import "core:c"
import readdir "../lib/readdir_files"

BUFFER_SIZE_OF_EACH_PATH :: 1024
DEBUG_PATH :: false
DEBUG_ERRORN :: false
DEBUG_READ_ERRORN :: false

main :: proc () {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)

    keyfor: rl.KeyboardKey
    keyfor = rl.GetKeyPressed()


    windown_dim :: n.int2{400, 100}

    // fmt.println ("Hello World")

    hashmap_paths := make(map[string]string)
    defer delete(hashmap_paths)

    something := os.get_env("PATH", context.temp_allocator)

    now_string := ""
    name_binary := ""

    do_readit := true

    counter := 0

    for name in strings.split_after(something, ":", context.temp_allocator) {
        // for name in strings.split_after("/bin:", ":", context.temp_allocator) { // problem reading /bin directory

        now_string = strings.trim_right(name, ":")
        fmt.println (" :: ", now_string)

        fd, err := os.open(now_string, os.O_RDONLY, 0)
        if !(err == 0) {

            if DEBUG_ERRORN {
                fmt.println("ERROR OPEN |", now_string, "|") // fmt.print(now_string)  // return
            }
            do_readit = false
        }
        defer os.close(fd)

        if do_readit {
            files_info, ok := os.read_dir(
                fd,
                BUFFER_SIZE_OF_EACH_PATH,
                context.temp_allocator,
            )
            if ok == 0 {
                if DEBUG_READ_ERRORN {
                    fmt.println ("ERROR READ ::: |", now_string, "|")
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
        } else {
            if DEBUG_ERRORN {
                fmt.println ("Do not Read |", now_string, "|")
            }
            do_readit = true
        }

        // fmt.println ( i )

    }

    // params := []string{"&"}

    // os.execvp("/usr/bin/caja &", params)


    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    current_speed: f32 = 6.0
    old_current_speed: f32 = current_speed

    pause: bool = false

    fmt.println ("counter :: ", counter)

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

            os.execvp("/usr/bin/thunar", []string{})
        }

        rl.DrawRectangle(0, 0, 30, 30, color_now)

        rl.ClearBackground(rl.WHITE)

        rl.DrawText("Spawn Rune", 100, 100, 20, rl.DARKGRAY)

        rl.EndDrawing()
    }
}

main_test :: proc () {

    counter := 0

    name_binary, now_string : string = "", ""

    fd, err := os.open("/bin", os.O_RDONLY, 0)
    files_info, ok := os.read_dir(
        fd,
        BUFFER_SIZE_OF_EACH_PATH,
        context.temp_allocator
    )
    if ok == 0 {
        if DEBUG_READ_ERRORN {
            fmt.println ("ERROR READ ::: |", now_string, "|")
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

    fmt.println (counter)

}

main_proc :: proc() {


    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)

    keyfor: rl.KeyboardKey
    keyfor = rl.GetKeyPressed()


    windown_dim :: n.int2{400, 100}

    // fmt.println ("Hello World")

    hashmap_paths := make(map[string]string)
    defer delete(hashmap_paths)

    something := os.get_env("PATH", context.temp_allocator)

    now_string := ""
    name_binary := ""

    do_readit := true

    counter := 0

    for name in strings.split_after(something, ":", context.temp_allocator) {
    // for name in strings.split_after("/bin:", ":", context.temp_allocator) { // problem reading /bin directory

        now_string = strings.trim_right(name, ":")
        fmt.println (" :: ", now_string)

        fd, err := os.open(now_string, os.O_RDONLY, 0)
        if !(err == 0) {

            if DEBUG_ERRORN {
                fmt.println("ERROR OPEN |", now_string, "|") // fmt.print(now_string)  // return
            }
            do_readit = false
        }
        defer os.close(fd)

        if do_readit {
            files_info, ok := os.read_dir(
                fd,
                BUFFER_SIZE_OF_EACH_PATH,
                context.temp_allocator,
            )
            if ok == 0 {
                if DEBUG_READ_ERRORN {
                    fmt.println ("ERROR READ ::: |", now_string, "|")
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
        } else {
            if DEBUG_ERRORN {
                fmt.println ("Do not Read |", now_string, "|")
            }
            do_readit = true
        }

        // fmt.println ( i )

    }

    // params := []string{"&"}

    // os.execvp("/usr/bin/caja &", params)


    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    current_speed: f32 = 6.0
    old_current_speed: f32 = current_speed

    pause: bool = false

    fmt.println ("counter :: ", counter)

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

            os.execvp("/usr/bin/thunar", []string{})
        }

        rl.DrawRectangle(0, 0, 30, 30, color_now)

        rl.ClearBackground(rl.WHITE)

        rl.DrawText("Spawn Rune", 100, 100, 20, rl.DARKGRAY)

        rl.EndDrawing()
    }

}
