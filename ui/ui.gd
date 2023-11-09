extends Control

signal countdown_done

@onready var current_score = $HBoxContainer/CurrentScore
@onready var high_score = $HBoxContainer2/HighScore
@onready var game_over_label = $GameOverLabel
@onready var pause_label = $PauseLabel
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var countdown = $CountdownPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_main_score_changed(value):
	current_score.text = str(value)

func _on_main_game_over(won):
	game_over_label.show()
	if won:
		game_over_label.text = "You Win!"
	else:
		game_over_label.text = "Game Over"

func _on_main_reset():
	countdown.start()

func _on_countdown_panel_countdown_over():
	emit_signal("countdown_done")

func _on_main_new_game():
	current_score.text = str(0)
	game_over_label.hide()

func _on_main_paused(value):
	if value:
		pause_label.show()
	else:
		pause_label.hide()
