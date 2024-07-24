extends Node2D

var SaveSystem = preload("res://SaveSystem.gd")
@onready var popup_msg = $Popup

func _ready():
	update_level_buttons()

func _on_button_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_button_2_pressed():
	if access_level(2):
		get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_3_pressed():
	if access_level(3):
		get_tree().change_scene_to_file("res://Scenes/level_3.tscn")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_4_pressed():
	#get_tree().change_scene_to_file("res://LEVEL_4.tscn")
	if access_level(4):
		get_tree().change_scene_to_file("res://LEVEL_4.tscn")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_5_pressed():
	#get_tree().change_scene_to_file("res://Scenes/level5.tscn")
	if access_level(5):
		get_tree().change_scene_to_file("res://terminal.gd")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_6_pressed():
	if access_level(6):
		get_tree().change_scene_to_file("res://terminal.gd")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_7_pressed():
	if access_level(7):
		get_tree().change_scene_to_file("res://terminal.gd")
	else:
		popup_msg.popup_centered()
	print("done")

func _on_button_8_pressed():
	if access_level(8):
		get_tree().change_scene_to_file("res://terminal.gd")
	else:
		popup_msg.popup_centered()
	print("done")


func access_level(level: int) -> bool:
	var all_button = $LevelButtons.get_children()
	var prvs_button = all_button[level - 2]
	print(prvs_button)
	if prvs_button.modulate == Color(0, 1, 0):
		print("true")
		return true
	print("false")
	return false


#TO MAKE LEVEL BUTTON TURN GREEN IF COMPLETED
func update_level_buttons():
	var Save = SaveSystem.new()
	var progress = Save.load_progress()
	for button in $LevelButtons.get_children():
		var level = int(button.name.replace("Button", ""))
		if level in progress["levels_completed"]:
			button.modulate = Color(0, 1, 0)


func _on_okay_pressed():
	popup_msg.hide()



