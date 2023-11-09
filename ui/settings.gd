extends Control
signal paddle_color
signal settings_closed

@onready var color_setting = $HBoxContainer/PaddleColor
	
func _on_button_pressed():
	emit_signal("settings_closed")
	hide()

func _on_main_paused(value):
	if value:
		visible = true
	else:
		visible = false

func _on_paddle_color_item_selected(index):
	var color = color_setting.get_item_text(index)
	emit_signal("paddle_color", color)
