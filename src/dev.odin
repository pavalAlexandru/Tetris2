package tetris

import "core:fmt"
import rl "vendor:raylib"

DrawDevGrid :: proc() {
	for j in 0 ..= 16 {
		for i in 0 ..= 24 {
			text: cstring = fmt.ctprintf("%v,%v", j, i)
			rl.DrawRectangleLines(
				i32(CANVA_BLOCK * i),
				i32(CANVA_BLOCK * j),
				CANVA_BLOCK,
				CANVA_BLOCK,
				rl.GRAY,
			)
			rl.DrawText(text, i32(CANVA_BLOCK * i) + 2, i32(CANVA_BLOCK * j) + 1, 10, rl.GRAY)
		}
	}

}
