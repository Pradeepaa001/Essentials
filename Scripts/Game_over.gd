extends Node2D

@onready var timer = $Timer
@onready var confirmation = $AcceptDialog

func _ready():

	timer.wait_time = 2.0
	timer.start()
	if confirmation == null:
		print("not found")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	confirmation.popup_centered()


func _on_accept_dialog_confirmed():
	get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")

