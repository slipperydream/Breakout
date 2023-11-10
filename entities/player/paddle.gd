extends CharacterBody2D

class_name Paddle 

@export var speed : int = 5
@export var buffer : int = 50
@onready var paddle_width = $Sprite2D.texture.get_width()
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var ball = get_tree().get_first_node_in_group("ball")
@onready var sensitivity : float = 1

var horz_speed = 0
var computer_controlled : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func get_input():
	var input_dir = Input.get_axis("left", "right")
	horz_speed = input_dir * speed * sensitivity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if computer_controlled:
		get_computer_movement()
	else:
		get_input()
	global_position.x += horz_speed
	global_position.x = clamp(global_position.x, paddle_width/2, screen_size.x-paddle_width/2)

func get_computer_movement():
	if ball.global_position.x > (global_position.x + paddle_width/2):
		horz_speed = 1 * speed
	elif ball.global_position.x < (global_position.x - paddle_width/2):
		horz_speed = -1 * speed
	else:
		horz_speed = 0
			
func hit():
	$AnimationPlayer.play("hit")
	
func reset():
	global_position = Vector2(screen_size.x/2, screen_size.y - buffer)
	$Sprite2D.scale.x = 1
	$CollisionShape2D.scale.x = 1

func _on_main_reset():
	reset()

func _on_settings_paddle_color(value):
	var color = get_color(value)
	$Sprite2D.modulate = color

func get_color(value):
	match value:
		"RED":
			return Color.RED
		"GREEN": 
			return Color.GREEN
		"BLUE":
			return Color.BLUE
		"YELLOW":
			return Color.YELLOW
		"PURPLE":
			return Color.PURPLE
		"ORANGE":
			return Color.ORANGE
		"WHITE":
			return Color.WHITE

func _on_settings_sensitivity_updated(value):
	sensitivity = value

func _on_ball_hit_ceiling():
	$Sprite2D.scale.x -= 0.1
	$Sprite2D.scale.x = max(0.5, $Sprite2D.scale.x)
	$CollisionShape2D.scale.x -= 0.1
	$CollisionShape2D.scale.x = max(0.5, $CollisionShape2D.scale.x)
	
