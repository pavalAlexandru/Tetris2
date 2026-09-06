package tetris

import "core:math/rand"
import rl "vendor:raylib"

generateTetromino :: proc(game: ^Game) {
	if !game.activeTetromino {
		game.clock = 0
		game.activeTetromino = true
		newType := TetrominoType(rand.int32_range(1, 7))
		game.currentTetromino = Tetromino {
			position = {4, 0},
			type     = newType,
			shape    = Shape[newType],
		}
	}
}

moveTetromino :: proc(game: ^Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.LEFT) {
		canMove := true

		for i in 0 ..< 4 {
			for j in 0 ..< 4 {
				if game.currentTetromino.shape[i][j] != 0 {
					if game.currentTetromino.position.x + j - 1 < 0 ||
					   game.board[game.currentTetromino.position.y + i][game.currentTetromino.position.x + j - 1] !=
						   0 {
						canMove = false
					}
				}
			}
		}

		if canMove {
			game.currentTetromino.position.x -= 1
		}
	}

	if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) {
		canMove := true

		for i in 0 ..< 4 {
			for j in 0 ..< 4 {
				if game.currentTetromino.shape[i][j] != 0 {
					if game.currentTetromino.position.x + j + 1 > 9 ||
					   game.board[game.currentTetromino.position.y + i][game.currentTetromino.position.x + j + 1] !=
						   0 {
						canMove = false
					}
				}
			}
		}

		if canMove {
			game.currentTetromino.position.x += 1
		}
	}

}

tetrominoFall :: proc(game: ^Game) {
	if game.clock >= 0.5 {
		canFall := true
		for i in 0 ..< 4 {
			for j in 0 ..< 4 {
				if game.currentTetromino.shape[i][j] != 0 {
					if game.currentTetromino.position.y + i + 1 > 19 ||
					   game.board[game.currentTetromino.position.y + i + 1][game.currentTetromino.position.x + j] !=
						   0 {
						canFall = false
					}
				}
			}
		}
		if canFall {
			game.currentTetromino.position.y += 1
		} else {
			for i in 0 ..< 4 {
				for j in 0 ..< 4 {
					if game.currentTetromino.shape[i][j] != 0 {
						game.board[game.currentTetromino.position.y + i][game.currentTetromino.position.x + j] =
							game.currentTetromino.shape[i][j]
					}

				}
			}
			game.activeTetromino = false

		}
		game.clock = 0
	}
}

UpdatePlaying :: proc(game: ^Game) {
	game.clock += rl.GetFrameTime()

	generateTetromino(game)
	moveTetromino(game)
	tetrominoFall(game)

}

UPDATE :: proc(game: ^Game) {

	switch game.currentState {
	case .PLAYING:
		UpdatePlaying(game)
	case .TITLE:
	case .HELP:
	}

}
