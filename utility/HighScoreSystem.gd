extends Node2D

signal new_high_score 
@export var high_score_file : String
var high_score : int = 0
	
func check_for_high_score(value):
	if value > high_score:
		high_score = value
		save_high_score(high_score)
		emit_signal("new_high_score")
		
func save_high_score(value):
	var file = FileAccess.open(high_score_file, FileAccess.WRITE)
	file.store_var(value)

func get_high_score():
	if not FileAccess.file_exists(high_score_file):
		print("No high scores file!")
		return
		
	var file = FileAccess.open(high_score_file, FileAccess.READ)
	var value = file.get_var()
	print(value)
	if value >= 0:
		high_score = value
		return high_score
	return 0
		
