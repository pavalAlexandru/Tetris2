package tetris

import "core:math/rand"
import rl "vendor:raylib"

generateTetromino :: proc(game: ^Game) {
	if !game.activeTetromino {
		game.clock = 0
		game.activeTetromino = true
		newType := TetrominoType(rand.int32_range(1, 8))
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

tetrominoFastFall :: proc(game: ^Game) {
	if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		game.clock *= 8
	}
}

rotateTetromino :: proc(game: ^Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.UP) {
		backupShape := game.currentTetromino.shape
		for i in 0 ..< 2 {
			for j in i ..< 3 - i {
				temp := game.currentTetromino.shape[i][j]
				game.currentTetromino.shape[i][j] = game.currentTetromino.shape[3 - j][i]
				game.currentTetromino.shape[3 - j][i] = game.currentTetromino.shape[3 - i][3 - j]
				game.currentTetromino.shape[3 - i][3 - j] = game.currentTetromino.shape[j][3 - i]
				game.currentTetromino.shape[j][3 - i] = temp
			}
		}
		canRotate := true

		for i in 0 ..< 4 {
			for j in 0 ..< 4 {
				if game.currentTetromino.shape[i][j] != 0 {
					if game.currentTetromino.position.x + j > 9 ||
					   game.board[game.currentTetromino.position.y + i][game.currentTetromino.position.x + j] !=
						   0 ||
					   game.currentTetromino.position.y + i > 19 ||
					   game.board[game.currentTetromino.position.y + i][game.currentTetromino.position.x + j] !=
						   0 {
						canRotate = false
					}
				}
			}
		}
		if !canRotate {
			game.currentTetromino.shape = backupShape
		}

	}
}

tetrominoHardDrop :: proc(game: ^Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		for {

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
				break
			}
		}
		game.clock = 0
	}
}

clearRow :: proc(game: ^Game) {
	for i in 0 ..< 20 {
		count := 0
		for j in 0 ..< 10 {
			if game.board[i][j] != 0 {count += 1}
		}
		if count == 10 {
			for k := i; k > 0; k -= 1 {
				for j in 0 ..< 10 {
					game.board[k][j] = game.board[k - 1][j]
				}
			}
		}
	}
}

UpdatePlaying :: proc(game: ^Game) {
	game.clock += rl.GetFrameTime()


	generateTetromino(game)
	moveTetromino(game)
	tetrominoFastFall(game)
	rotateTetromino(game)
	tetrominoHardDrop(game)
	tetrominoFall(game)
	clearRow(game)

}

UPDATE :: proc(game: ^Game) {

	switch game.currentState {
	case .PLAYING:
		UpdatePlaying(game)
	case .TITLE:
	case .HELP:
	}

}
