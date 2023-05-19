package pong_odin

import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rl "vendor:raylib"
import rand "core:math/rand"
import "core:strings"
import os "core:os"

BUFFER_SIZE_OF_EACH_PATH :: 1024

main :: proc() {


    windown_dim :: n.int2{400, 100}

    // fmt.println ("Hello World")

    rl.InitWindow(windown_dim.x, windown_dim.y, "Pong Odin")
    rl.SetTargetFPS(60)

    keyfor: rl.KeyboardKey
    keyfor = rl.GetKeyPressed()

    is_running :: true

    something := os.get_env("PATH", context.temp_allocator)

    now_string := ""

    do_readit := true

    for name in strings.split_after(something, ":", context.temp_allocator) {

        now_string = strings.trim_right(name, ":")

        fd, err := os.open(now_string, os.O_RDONLY, 0)
        if !(err == 0) {
            // fmt.println("ERROR ")       // fmt.print(now_string)           // return
            do_readit = false
        }
        defer os.close(fd)

        if do_readit {
            fileinfo, ok := os.read_dir(
                fd,
                BUFFER_SIZE_OF_EACH_PATH,
                context.temp_allocator,
            )
            fmt.println(fileinfo)
            fmt.println(ok)
        } else {
            do_readit = true
        }

        // fmt.println ( i )

    }


    // fmt.println(keyfor)

    rl.BeginDrawing()

    current_speed: f32 = 6.0
    old_current_speed: f32 = current_speed

    pause: bool = false

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
        }

        rl.DrawRectangle(0, 0, 30, 30, color_now)

        rl.ClearBackground(rl.WHITE)

        rl.DrawText("Pong Odin!", 100, 100, 20, rl.DARKGRAY)

        rl.EndDrawing()
    }

}
