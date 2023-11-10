extends Control
signal paddle_color
signal settings_closed
signal num_rows_updated
signal sensitivity_updated

@onready var color_setting = $GridContainer/HBoxContainer/PaddleColor
@onready var paddle = get_tree().get_first_node_in_group("paddle")
@onready var sensitivity = $GridContainer/HBoxContainer3/Sensitivity
@onready var rows = $GridContainer/HBoxContainer2/NumRows

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

func _on_num_rows_value_changed(value):
	emit_signal("num_rows_updated", value)

func _on_visibility_changed():
	if visible:
		sensitivity.value = paddle.sensitivity
	

func _on_sensitivity_value_changed(value):
	emit_signal("sensitivity_updated", value)
