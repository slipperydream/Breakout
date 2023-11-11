extends Node2D

signal score_changed
signal new_game
signal level_beat
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

@export var levels : Array[Level]
@export var brick_scene : PackedScene
@export var rows : int = 5
@export var bricks_per_row : int = 16
@export var start_pt : Vector2 = Vector2(67,100)

var row_height : int = 24
var brick_width : int = 67
var score : int = 0
var max_lives : int = 3
var lives : int = 0
var current_state = state.WAITING
var current_level : int = 0
var bricks_broken : int = 0
var total_bricks : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttractModeTimer.start()
	current_state = state.WAITING
	
func check_for_win():
	await get_tree().create_timer(0.5).timeout
	var win = false
	
	if bricks_broken >= total_bricks:
		win = true
	if win:
		if current_level == levels.size() -1:
			emit_signal("game_won")
		else:
			emit_signal('level_beat')
			if current_level % 3 == 0:
				lives += 1
				lives = min(lives, max_lives)
		
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
	create_board(levels[current_level])
	current_state = state.PLAYING
	paddle.computer_controlled = false
	
func create_board(level):
	bricks_broken = 0
	total_bricks = 0
	var new_level = load(level.resource_path)
	for row in new_level.bricks:
		var brick_row = level.bricks[row]
		for num in bricks_per_row:
			if brick_row[num] > 0:
				var new_brick = brick_scene.instantiate()
				var color = get_brick_color(brick_row[num])
				var pos = start_pt
				pos.x = pos.x + (num * brick_width) 
				pos.y = pos.y + (row * row_height)
				new_brick.start(color, pos, row, num)
				new_brick.brick_broken.connect(self._on_brick_broken)
				$CanvasLayer.add_child(new_brick)
				total_bricks += 1
			
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
	bricks_broken += 1
	check_for_win()
	
func update_score(value):
	score += value
	emit_signal("score_changed", score)


func _on_ball_out_of_bounds():
	reset_play()
	
func get_brick_color(value):
	match value:
		Constants.BrickType.SNOW:
			return Color.SNOW
		Constants.BrickType.CHOCOLATE: 
			return Color.CHOCOLATE
		Constants.BrickType.GOLDENROD:
			return Color.GOLDENROD
		Constants.BrickType.FOREST_GREEN:
			return Color.FOREST_GREEN
		Constants.BrickType.DARK_CYAN:
			return Color.DARK_CYAN
		Constants.BrickType.DODGER_BLUE:
			return Color.DODGER_BLUE
		Constants.BrickType.DARK_ORCHID:
			return Color.DARK_ORCHID
		Constants.BrickType.MAROON:
			return Color.MAROON
