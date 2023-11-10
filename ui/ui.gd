extends Control

signal countdown_done

@onready var current_score = $HBoxContainer/CurrentScore
@onready var high_score = $HBoxContainer2/HighScore
@onready var game_end_label = $GameEndLabel
@onready var pause_label = $PauseLabel
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var countdown = $CountdownPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_high_score()
	HighScoreSystem.connect("new_high_score",update_high_score)
	
func update_high_score():
	high_score.text = str(HighScoreSystem.get_high_score())


func _on_main_score_changed(value):
	current_score.text = str(value)

func _on_main_game_over():
	game_end_label.show()
	game_end_label.text = "Game Over"

func _on_main_reset():
	countdown.start()

func _on_countdown_panel_countdown_over():
	emit_signal("countdown_done")

func _on_main_new_game():
	current_score.text = str(0)
	game_end_label.hide()
	$Life1.visible = true
	$Life2.visible = true
	$Life3.visible = true

func _on_main_paused(value):
	if value:
		pause_label.show()
	else:
		pause_label.hide()

func _on_main_game_won():
	game_end_label.show()
	game_end_label.text = "You Win!"

func _on_main_ball_lost():
	if $Life1.visible:
		$Life1.visible = false
	elif $Life2.visible:
		$Life2.visible = false
	else:
		$Life3.visible = false

