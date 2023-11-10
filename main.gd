extends Node2D

signal score_changed
signal new_game
signal game_won
signal game_over
signal reset
signal ball_lost
signal paused

enum state {WAITING, ATTRACT, PLAYING}
@onready var paddle = $CanvasLayer/Paddle
@onready var ball = $CanvasLayer/Ball
@onready var main_menu = $CanvasLayer/MainMenu
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var settings = $CanvasLayer/Settings

@export var brick_scene : PackedScene
@export var rows : int = 5
@export var bricks_per_row : int = 16
@export var start_pt : Vector2 = Vector2(67,300)

var row_height : int = 24
var brick_width : int = 67
var score : int = 0
var max_lives : int = 3
var lives : int = 0
var current_state = state.WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttractModeTimer.start()
	current_state = state.WAITING
	
func check_for_win():
	await get_tree().create_timer(0.5).timeout
	var win = false
	var count = get_tree().get_nodes_in_group("bricks").size()
	if count <= 0:
		win = true
	if win:
		emit_signal("game_won")
		
func reset_play():
	emit_signal("reset")
	reset_ball()
	
func reset_ball():
	ball.reset()

func _on_ui_countdown_done():
	ball.start_moving()

func _on_game_over():
	clean_up_and_restart()
	
func _on_game_won():
	clean_up_and_restart()
	
func clean_up_and_restart():
	HighScoreSystem.check_for_high_score(score)
	get_tree().call_group("bricks", "queue_free")
	await get_tree().create_timer(2).timeout
	current_state = state.WAITING
	main_menu.show()
	$AttractModeTimer.start()

func _on_main_menu_open_settings():
	settings.show()
	settings.rows.value = rows
	
func _input(event):
	if current_state == state.ATTRACT:
		emit_signal("game_over")
		
	if event.is_action_pressed("pause"):
		if get_tree().paused:			
			get_tree().paused = false
			emit_signal("paused", get_tree().paused)
		else:
			get_tree().paused = true
			emit_signal("paused", get_tree().paused)
			

func _on_settings_settings_closed():
	if get_tree().paused:
		get_tree().paused = false

func _on_attract_mode_timer_timeout():
	if current_state == state.WAITING:
		paddle.computer_controlled = true
		current_state = state.ATTRACT
		emit_signal("new_game")

func _on_main_menu_play_game():
	reset_play()
	emit_signal("new_game")
	lives = max_lives
	create_board()
	current_state = state.PLAYING
	paddle.computer_controlled = false
	
func create_board():
	for row in rows:
		for num in bricks_per_row:
			var new_brick = brick_scene.instantiate()
			var color = get_row_color(row)
			var pos = start_pt
			pos.x = pos.x + (num * brick_width)
			pos.y = pos.y - (row * row_height)
			new_brick.start(row, color, pos, num)
			new_brick.brick_broken.connect(self._on_brick_broken)
			$CanvasLayer.add_child(new_brick)

func get_row_color(row):
	match row:
		0:
			return Color.SNOW
		1: 
			return Color.CHOCOLATE
		2:
			return Color.GOLDENROD
		3:
			return Color.FOREST_GREEN
		4:
			return Color.DARK_CYAN
		5:
			return Color.DODGER_BLUE
		6:
			return Color.DARK_ORCHID
		7:
			return Color.MAROON
			
func _on_ball_lost():
	lives -= 1
	if lives <= 0:
		emit_signal("game_over")
	else:
		reset_play()

func _on_bottom_body_entered(body):
	if current_state != state.WAITING:
		emit_signal("ball_lost")

func _on_settings_num_rows_updated(value):
	rows = value
		
func _on_brick_broken(value):
	update_score(value)
	
func update_score(value):
	score += value
	emit_signal("score_changed", score)


func _on_ball_out_of_bounds():
	reset_play()
