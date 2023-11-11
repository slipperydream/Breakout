extends AudioStreamPlayer2D

@export var song_dir : String = "res://sounds/music/"
@export var max_volume : int = -15

var current_song : AudioStreamOggVorbis
var playlist : Array[AudioStreamOggVorbis] = []
var default_fade_time : float = 1.25
var loops : int = 0
var max_loops : int = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	get_songs(song_dir)
	var song = get_random_song()
	play_song(song, default_fade_time)
		

func get_songs(path):
	var dir = DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == 'ogg':
				var song_title = path+file_name
				var song = load(song_title)
				playlist.append(song)
			file_name = dir.get_next()
		dir.list_dir_end()
		
func _on_finished():
	if loops >= max_loops:
		var song = get_random_song()
		play_song(song, default_fade_time)
	else:
		play_song(current_song, default_fade_time)

func fade_in(fade_time=default_fade_time):
	if get_child_count() > 0:
		var child = get_child(0)
		var tween = create_tween()
		tween.tween_property(child, "volume_db", max_volume, fade_time)

func fade_out(fade_time=default_fade_time):
	if get_child_count() > 0:
		var child= get_child(0)
		var tween = create_tween()
		tween.tween_property(child, "volume_db", -80, fade_time)
	
func get_random_song():
	var song = playlist[randi() % playlist.size()]
	return song
	
func play_song(song, fade_time):
	# TODO: Revisit this so the fading is smoother
	current_song = song
	loops += 1
	fade_out(fade_time)
	await get_tree().create_timer(fade_time).timeout
	for child in get_children():
		remove_child(child)
		
	var bg_music = AudioStreamPlayer.new()
	bg_music.bus = bus
	bg_music.stream = load(song.resource_path)
	bg_music.autoplay = true
	bg_music.volume_db = -20
	add_child(bg_music)
	fade_in(fade_time)
	
