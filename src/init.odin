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
	.BLUE   = {{0, 0, 2, 0}, {0, 0, 2, 0}, {0, 0, 2, 0}, {0, 2, 2, 0}},
	.ORANGE = {{0, 3, 0, 0}, {0, 3, 0, 0}, {0, 3, 0, 0}, {0, 3, 3, 0}},
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
	board:            [20][10]int,
	textures:         [TetrominoType]rl.Texture2D,
	frameTexture:     rl.Texture2D,
}

INIT :: proc() -> (game: Game) {

	rl.SetExitKey(rl.KeyboardKey.KEY_NULL)
	rl.SetTargetFPS(60)

	game.currentState = .TITLE
	game.exitSignal = false

	game.textures[.CYAN] = rl.LoadTexture("../assets/cyan.png")
	game.textures[.BLUE] = rl.LoadTexture("../assets/blue.png")
	game.textures[.ORANGE] = rl.LoadTexture("../assets/orange.png")
	game.textures[.YELLOW] = rl.LoadTexture("../assets/yellow.png")
	game.textures[.GREEN] = rl.LoadTexture("../assets/green.png")
	game.textures[.PURPLE] = rl.LoadTexture("../assets/purple.png")
	game.textures[.RED] = rl.LoadTexture("../assets/red.png")

	game.frameTexture = rl.LoadTexture("../assets/frame.png")

	k := 0
	for i in 0 ..< 20 {
		for j in 0 ..< 10 {
			game.board[i][j] = k
			k += 1
			k = k % 8
		}
	}

	return game
}
