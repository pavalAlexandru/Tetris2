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

DrawMockData :: proc() {
	rl.DrawText("Andu", i32(CANVA_BLOCK * 10), i32(CANVA_BLOCK * 9), 20, rl.BLUE)
	rl.DrawText("100000", i32(CANVA_BLOCK * 13), i32(CANVA_BLOCK * 9), 20, rl.BLUE)
	rl.DrawText("GoldenApe", i32(CANVA_BLOCK * 10), i32(CANVA_BLOCK * 10), 20, rl.BLUE)
	rl.DrawText("999", i32(CANVA_BLOCK * 13), i32(CANVA_BLOCK * 10), 20, rl.BLUE)
}
