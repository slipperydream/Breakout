extends Panel

signal countdown_over

@onready var clock = $clock
var countdown_time : int = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func start():
	visible = true
	update_clock()
	$Timer.start()

func _on_timer_timeout():
	countdown_time -= 1
	update_clock()
	if countdown_time > 0:
		$Timer.start()
	else:
		emit_signal("countdown_over")
		countdown_time = 3
		visible = false

func update_clock():
	clock.text = str(countdown_time)
