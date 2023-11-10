extends StaticBody2D

class_name Brick

signal brick_broken

@export var base_points : int = 1
@onready var main = get_tree().get_first_node_in_group("main")
var row : int = 1
var hp : int = 1

func hit():
	hp -= 1
	if hp <= 0:
		emit_signal("brick_broken", base_points * row)
		queue_free()
	else:
		var tween = create_tween()
		tween.tween_property($Sprite2D, "modulate.a", 55, 0.3)
		tween.tween_property($Sprite2D, "modulate.a", 255, 0.3)

func start(in_row, color, pos, num):
	$Sprite2D.modulate = color
	row = in_row + 1
	global_position = pos
	$Label.text = str(num)
