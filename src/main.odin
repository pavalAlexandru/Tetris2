package tetris

import rl "vendor:raylib"

dev := false

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)

	game := INIT()

	for !rl.WindowShouldClose() {

		if game.exitSignal {break}

		rl.BeginDrawing()

		rl.ClearBackground(rl.WHITE)

		if dev {DrawDevGrid()}
		if rl.IsKeyPressed(rl.KeyboardKey.ONE) {dev = !dev}


		DRAW(&game)

		rl.EndDrawing()

	}

	for texture in game.textures {
		rl.UnloadTexture(texture)
	}
	rl.UnloadTexture(game.frameTexture)

	rl.CloseWindow()
}
