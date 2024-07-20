extends Node2D

var level_title = "The Journey Begins"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
const Terminal = preload("res://Scripts/terminal.gd")
var terminal = Terminal.new()

func _ready():
	var output = $TextEdit
	output.text += level_title + "\n"
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	output.text += level_description + "\nSetup commands:\n" + commands
	update_icons()


func task1_status() -> bool:
	print("4")
	var dir = DirAccess.open("res://user")
	print("heh")
	if dir.dir_exists("planet"):
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/planet"
	
func task3_status() -> bool:
	print("h m")
	var required_files = ["resource1", "resource2", "resource3"]
	var files_in_planet = terminal.execute(["ls", "\\user/planet"]).split("\n")
	print(files_in_planet)
	for file in required_files:
		print(file)
		if file not in files_in_planet:
			return false
	return true
	
func update_icons():
	if task1_status():
		$ColorRect1.color  = Color(0,1,0)
		print("task1:", task1_status())

	else:

		$ColorRect1.color  = Color(1,0,0)
		print("task1:", task1_status())

		

	if task2_status():
		print("task2:", task2_status())
		$ColorRect2.color  = Color(0,1,0)

	else:

		$ColorRect2.color  = Color(1,0,0)
		print("task2:", task2_status())

	
	if task3_status():
		print("task3:", task3_status())
		$ColorRect3.color  = Color(0,1,0)

	else:
		print("task3:", task3_status())
		$ColorRect3.color  = Color(1,0,0)




func _on_check_pressed():
	var output = $TextEdit
	update_icons()
	if task1_status() and task2_status() and task3_status():
		output.text += "\ntasks completed\n"
	else:
		output.text += "\ntasks are not completed\n"






#CHECKING COMPLETION AND SAVING IN DICTIONARY


func is_level_completed() -> bool:
	if task1_status() and task2_status() and task3_status():
		return true
	else:
		return false


func level_completed():
	if is_level_completed():
		var current_level = get_current_level()
		SaveSystem.save_progress(current_level)
		get_tree().change_scene("res://LevelSelector.tscn") 


func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))
