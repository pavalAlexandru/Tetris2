package tetris

import rl "vendor:raylib"

SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800
WINDOW_TITLE :: "Tetris"
CANVA_BLOCK :: 50 //canva 16 x 24
BUTTON_WIDTH :: CANVA_BLOCK * 3
BUTTON_HEIGHT :: CANVA_BLOCK

TetrominoType :: enum {
	NULL,
	CYAN,
	BLUE,
	ORANGE,
	YELLOW,
	GREEN,
	PURPLE,
	RED,
}

Shape: [TetrominoType][4][4]int = {
	.NULL   = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},
	.CYAN   = {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}},
	.BLUE   = {{0, 0, 2, 0}, {0, 0, 2, 0}, {0, 2, 2, 0}, {0, 0, 0, 0}},
	.ORANGE = {{0, 3, 0, 0}, {0, 3, 0, 0}, {0, 3, 3, 0}, {0, 0, 0, 0}},
	.YELLOW = {{0, 0, 0, 0}, {0, 4, 4, 0}, {0, 4, 4, 0}, {0, 0, 0, 0}},
	.GREEN  = {{0, 0, 0, 0}, {0, 5, 5, 0}, {5, 5, 0, 0}, {0, 0, 0, 0}},
	.PURPLE = {{0, 0, 0, 0}, {6, 6, 6, 0}, {0, 6, 0, 0}, {0, 0, 0, 0}},
	.RED    = {{0, 0, 0, 0}, {7, 7, 0, 0}, {0, 7, 7, 0}, {0, 0, 0, 0}},
}

Tetromino :: struct {
	position: [2]int,
	type:     TetrominoType,
	shape:    [4][4]int,
}

State :: enum {
	TITLE,
	HELP,
	PLAYING,
}

Game :: struct {
	currentState:     State,
	exitSignal:       bool,
	score:            int,
	currentTetromino: Tetromino,
	activeTetromino:  bool,
	board:            [20][10]int,
	textures:         [TetrominoType]rl.Texture2D,
	frameTexture:     rl.Texture2D,
	clock:            f32,
	activeGame:       bool,
}

LoadAssets :: proc(game: ^Game) {
	cyan_bytes := #load("../assets/cyan.png")
	blue_bytes := #load("../assets/blue.png")
	orange_bytes := #load("../assets/orange.png")
	yellow_bytes := #load("../assets/yellow.png")
	green_bytes := #load("../assets/green.png")
	purple_bytes := #load("../assets/purple.png")
	red_bytes := #load("../assets/red.png")

	frame_bytes := #load("../assets/frame.png")

	cyan_image := rl.LoadImageFromMemory(".png", raw_data(cyan_bytes), i32(len(cyan_bytes)))
	blue_image := rl.LoadImageFromMemory(".png", raw_data(blue_bytes), i32(len(blue_bytes)))
	orange_image := rl.LoadImageFromMemory(".png", raw_data(orange_bytes), i32(len(orange_bytes)))
	yellow_image := rl.LoadImageFromMemory(".png", raw_data(yellow_bytes), i32(len(yellow_bytes)))
	green_image := rl.LoadImageFromMemory(".png", raw_data(green_bytes), i32(len(green_bytes)))
	purple_image := rl.LoadImageFromMemory(".png", raw_data(purple_bytes), i32(len(purple_bytes)))
	red_image := rl.LoadImageFromMemory(".png", raw_data(red_bytes), i32(len(red_bytes)))

	frame_image := rl.LoadImageFromMemory(".png", raw_data(frame_bytes), i32(len(frame_bytes)))

	game.textures[.CYAN] = rl.LoadTextureFromImage(cyan_image)
	game.textures[.BLUE] = rl.LoadTextureFromImage(blue_image)
	game.textures[.ORANGE] = rl.LoadTextureFromImage(orange_image)
	game.textures[.YELLOW] = rl.LoadTextureFromImage(yellow_image)
	game.textures[.GREEN] = rl.LoadTextureFromImage(green_image)
	game.textures[.PURPLE] = rl.LoadTextureFromImage(purple_image)
	game.textures[.RED] = rl.LoadTextureFromImage(red_image)

	game.frameTexture = rl.LoadTextureFromImage(frame_image)

	rl.UnloadImage(cyan_image)
	rl.UnloadImage(blue_image)
	rl.UnloadImage(orange_image)
	rl.UnloadImage(yellow_image)
	rl.UnloadImage(green_image)
	rl.UnloadImage(purple_image)
	rl.UnloadImage(red_image)

	rl.UnloadImage(frame_image)

}

ResetLevel :: proc(game: ^Game) {
	game.score = 0
	game.activeTetromino = false
	for i in 0 ..< 20 {
		for j in 0 ..< 10 {
			game.board[i][j] = 0
		}
	}
}

INIT :: proc() -> (game: Game) {

	rl.SetExitKey(rl.KeyboardKey.KEY_NULL)
	rl.SetTargetFPS(60)

	game.currentState = .TITLE
	game.exitSignal = false
	game.activeTetromino = false

	LoadAssets(&game)

	// k := 0
	// for i in 0 ..< 20 {
	// 	for j in 0 ..< 10 {
	// 		game.board[i][j] = k
	// 		k += 1
	// 		k = k % 8
	// 	}
	// }

	return game
}
