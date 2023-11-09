extends Node2D

signal score_changed
signal new_game
signal game_over
signal reset
signal paused

enum state {WAITING, ATTRACT, PLAYING}
@onready var paddle = $CanvasLayer/Paddle
@onready var ball = $CanvasLayer/Ball
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var settings = $CanvasLayer/Settings

var score : int = 0
var current_state = state.WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttractModeTimer.start()
	current_state = state.WAITING
	
func check_for_win():
	var win = false
	#if bricks == gone:
		#win = true
	if win:
		emit_signal("game_over", true)
		
func reset_play():
	emit_signal("reset")
	
func reset_ball():
	ball.reset()

func _on_ui_countdown_done():
	reset_ball()

func _on_game_over(_value):
	await get_tree().create_timer(2).timeout
	current_state = state.WAITING
	$CanvasLayer/MainMenu.show()

func _on_main_menu_open_settings():
	settings.show()
	
func _input(event):
	if current_state == state.ATTRACT:
		emit_signal("game_over", false)
		
	if event.is_action_pressed("pause"):
		if get_tree().paused:			
			emit_signal("paused", get_tree().paused)
			get_tree().paused = false
		else:
			emit_signal("paused", get_tree().paused)
			get_tree().paused = true

func _on_settings_settings_closed():
	if get_tree().paused:
		get_tree().paused = false

func _on_attract_mode_timer_timeout():
	paddle.computer_controlled = true
	current_state = state.ATTRACT
	emit_signal("new_game")

func _on_main_menu_play_game():
	reset_play()
	emit_signal("new_game")
	current_state = state.PLAYING
	paddle.computer_controlled = false
