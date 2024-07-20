extends Node2D

var level_title = "\tThe Journey Begins\n"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
var task_scene = load("res://Scenes/task.tscn")

var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()

func _ready():
	var output = $RichTextLabel
	output.text += level_title + "\n"
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	output.text += level_description + "\nSetup commands:\n" + commands
	add_tasks()
	
func add_tasks():
	var task_count = 3; var task
	var instructions = ["Create planet", "Enter plant", "Create resources:\nresource1\nresource2\nresource3"]
	var task_manager = $Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer
	for idx in task_count:
		task = task_scene.instantiate().duplicate()
		var instruction = task.get_node("HBoxContainer/Panel/RichTextLabel")
		instruction.text = instructions[idx]
		task_manager.add_child(task)
		task.position = Vector2(0, (task_manager.get_child_count() - 1) * 75)

func task1_status() -> bool:
	var dir = DirAccess.open("res://user")
	if dir.dir_exists("planet"):
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/planet"
	
func task3_status() -> bool:
	var commandline = $Terminal
	var required_files = ["resource1", "resource2", "resource3"]
	var files_in_planet = commandline.execute("ls").split("\n")
	print(files_in_planet)
	for file in required_files:
		if file not in files_in_planet:
			return false
	return true
	
func update_status():
	var task_count = 3
	var check_functions = [task1_status, task2_status, task3_status]
	
	for idx in task_count:
		var task_manager = get_node("Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer")
		var task = task_manager.get_child(idx)
		var task_color = task.get_node("HBoxContainer/Panel/ColorRect")
		task_color.color = Color(0,1,0) if check_functions[idx].call() else Color(1,0,0)
		print("done")
		

func _on_check_pressed():
	update_status()
	level_completed()
	
#CHECKING COMPLETION AND SAVING IN DICTIONARY
	
func is_level_completed() -> bool:
	return task1_status() and task2_status() and task3_status()

func level_completed():
	if is_level_completed():
		var current_level = get_current_level()
		Save.save_progress(current_level)
		get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))
	
