extends CharacterBody2D

class_name Ball

@export var max_speed : int = 250
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var sound_player = $AudioStreamPlayer2D
@onready var paddle = get_tree().get_first_node_in_group("paddle")
@export var hit_sounds : Array[AudioStreamOggVorbis] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		play_hit()
		var collider = collision.get_collider()
		if collider is Paddle:
			velocity = global_position - collider.global_position
			velocity = velocity.normalized() * max_speed
		else:
			velocity = velocity.bounce(collision.get_normal())
		if collider.has_method("hit"):
			collider.hit()

func reset():
	global_position =  Vector2(screen_size.x/2, screen_size.y/2)
	var vel_x = randi_range(-0.5,.5) * max_speed
	var vel_y = max_speed
	velocity = Vector2(vel_x, vel_y)

func play_hit():
	sound_player.volume_db = -20
	var sound = hit_sounds[randi() % hit_sounds.size()]
	sound_player.stream = sound
	sound_player.play()



