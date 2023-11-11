extends StaticBody2D

class_name Brick

signal brick_broken

@export var points : int = 1
@onready var main = get_tree().get_first_node_in_group("main")
var hp : int = 1

func hit():
	hp -= 1
	if hp <= 0:
		emit_signal("brick_broken", points)
		queue_free()
	else:
		var tween = create_tween()
		tween.tween_property($Sprite2D, "modulate.a", 55, 0.3)
		tween.tween_property($Sprite2D, "modulate.a", 255, 0.3)

func start(color, pos, row, num):
	$Sprite2D.modulate = color
	global_position = pos
	points = row + 1
	$Label.text = str(num)
