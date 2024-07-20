extends Node2D

var SaveSystem = preload("res://SaveSystem.gd")

func _ready():
	update_level_buttons()
	print('3')
	
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")

func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/level3.tscn")


func _on_button_4_pressed():
	get_tree().change_scene_to_file("res://terminal.gd")


func _on_button_5_pressed():
	get_tree().change_scene_to_file("res://terminal.gd")


func _on_button_6_pressed():
	get_tree().change_scene_to_file("res://terminal.gd")


func _on_button_7_pressed():
	get_tree().change_scene_to_file("res://terminal.gd")


func _on_button_8_pressed():
	get_tree().change_scene_to_file("res://terminal.gd")





#TO MAKE LEVEL BUTTON TURN GREEN IF COMPLETED

func update_level_buttons():
	var Save = SaveSystem.new()
	var progress = Save.load_progress()
	for button in $LevelButtons.get_children():
		var level = int(button.name.replace("Button", "")) + 1
		if level in progress["levels_completed"]:
			button.modulate = Color(0, 1, 0)
