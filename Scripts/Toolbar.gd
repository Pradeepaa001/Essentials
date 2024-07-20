extends Node2D

#@onready var quit_button = $Button2


@onready var confirm_dialog = $ConfirmationDialog
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")


func _on_button_2_pressed():
	confirm_dialog.popup_centered()

func _on_confirmation_dialog_canceled():
	pass
	
func _on_confirmation_dialog_confirmed():
	get_tree().quit()
