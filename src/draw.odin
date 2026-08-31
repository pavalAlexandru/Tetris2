package tetris

import rl "vendor:raylib"

DrawTitle :: proc(game: ^Game) {
	rl.DrawText(
		"Welcome to Tetris",
		i32(CANVA_BLOCK * 8) + CANVA_BLOCK / 3,
		i32(CANVA_BLOCK * 2) + CANVA_BLOCK / 5,
		40,
		rl.BLUE,
	)

	if rl.GuiButton(
		rl.Rectangle{CANVA_BLOCK * 6, CANVA_BLOCK * 5, BUTTON_WIDTH, BUTTON_HEIGHT},
		"Play",
	) {
		game.currentState = .PLAYING
	}

	if rl.GuiButton(
		rl.Rectangle{CANVA_BLOCK * 15, CANVA_BLOCK * 5, BUTTON_WIDTH, BUTTON_HEIGHT},
		"Help",
	) {
		game.currentState = .HELP
	}

	rl.DrawText(
		"High Scores:",
		i32(CANVA_BLOCK * 10) + CANVA_BLOCK / 6,
		i32(CANVA_BLOCK * 7) + CANVA_BLOCK / 5,
		30,
		rl.BLUE,
	)

	DrawMockData()

	if rl.GuiButton(
		rl.Rectangle{CANVA_BLOCK * 20, CANVA_BLOCK * 14, BUTTON_WIDTH, BUTTON_HEIGHT},
		"Exit",
	) {
		game.exitSignal = true
	}

}

DrawHelp :: proc(game: ^Game) {
	rl.DrawText(
		"How To Play",
		i32(CANVA_BLOCK * 9) + CANVA_BLOCK / 2,
		i32(CANVA_BLOCK * 2) + CANVA_BLOCK / 5,
		40,
		rl.BLUE,
	)

	rl.DrawText(
		"LEFT and RIGHT ARROWS to move the tetromino",
		i32(CANVA_BLOCK * 7),
		i32(CANVA_BLOCK * 4),
		20,
		rl.BLUE,
	)
	rl.DrawText(
		"UP ARROW to rotate the tetromino",
		i32(CANVA_BLOCK * 7),
		i32(CANVA_BLOCK * 5),
		20,
		rl.BLUE,
	)
	rl.DrawText(
		"DOWN ARROW to accelerate the tetromino downwards",
		i32(CANVA_BLOCK * 7),
		i32(CANVA_BLOCK * 6),
		20,
		rl.BLUE,
	)
	rl.DrawText(
		"SPACE to hard drop the tetromino",
		i32(CANVA_BLOCK * 7),
		i32(CANVA_BLOCK * 7),
		20,
		rl.BLUE,
	)
	rl.DrawText("ESC to pause", i32(CANVA_BLOCK * 7), i32(CANVA_BLOCK * 8), 20, rl.BLUE)

	if rl.GuiButton(
		rl.Rectangle {
			CANVA_BLOCK * 10 + CANVA_BLOCK / 2,
			CANVA_BLOCK * 10,
			BUTTON_WIDTH,
			BUTTON_HEIGHT,
		},
		"Back To Title",
	) {
		game.currentState = .TITLE
	}
}

DrawPlaying :: proc(game: ^Game) {
	rl.DrawRectangle(
		i32(CANVA_BLOCK * 4),
		i32(CANVA_BLOCK * 3),
		i32(CANVA_BLOCK * 5),
		i32(CANVA_BLOCK * 10),
		rl.BLACK,
	)
	rl.DrawRectangleLines(
		i32(CANVA_BLOCK * 4),
		i32(CANVA_BLOCK * 3),
		i32(CANVA_BLOCK * 5),
		i32(CANVA_BLOCK * 10),
		rl.BLUE,
	)

	rl.DrawTextureEx(
		game.frameTexture,
		rl.Vector2{f32(CANVA_BLOCK * 3 + CANVA_BLOCK / 2), f32(CANVA_BLOCK * 2 + CANVA_BLOCK / 2)},
		0,
		5,
		rl.WHITE,
	)

	DrawBoard :: proc(game: ^Game) {
		for i in 0 ..< 20 {
			for j in 0 ..< 10 {
				if game.board[i][j] != 0 {
					type := TetrominoType(game.board[i][j])
					rl.DrawTextureEx(
						game.textures[type],
						rl.Vector2 {
							f32(CANVA_BLOCK * 4 + CANVA_BLOCK / 2 * j),
							f32(CANVA_BLOCK * 3 + CANVA_BLOCK / 2 * i),
						},
						0,
						5,
						rl.WHITE,
					)
				}
			}
		}
	}

	DrawBoard(game)

	rl.DrawText(
		"Score: 3000",
		i32(CANVA_BLOCK * 14 + CANVA_BLOCK / 3),
		i32(CANVA_BLOCK * 3),
		20,
		rl.BLUE,
	)

	if rl.GuiButton(
		rl.Rectangle{CANVA_BLOCK * 14, CANVA_BLOCK * 12, BUTTON_WIDTH, BUTTON_HEIGHT},
		"Quit",
	) {
		game.currentState = .TITLE
	}
}


DRAW :: proc(game: ^Game) {
	switch game.currentState {
	case .TITLE:
		DrawTitle(game)
	case .HELP:
		DrawHelp(game)
	case .PLAYING:
		DrawPlaying(game)
		DrawPlaying(game)
	}
}
