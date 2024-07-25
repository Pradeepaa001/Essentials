extends Node2D
var level_intro = "\t\t\tThe Journey Begins\n\nWelcome to GRID, Agent 101!\nWe are exited to have you with us.
Your first set of tasks will help you get familiar with the system.
Refer to the task manager to find your tasks.
Find your level manual in the help section of your toolbar.
You can use the Level Manual to finish your tasks"

var level_congrats_message = "Well done, Explorer! You've gathered your first resources."

var level_manual = "\nmkdir - make directories
Create the directory, if they do not already exist.
					   mkdir <DIRECTORY_NAME>

cd - change directory
Navigate to a specific directory by specifying its path or the name of the directory
					   cd <DIRECTORY_NAME>
The command 'cd ..' can be used to return to the previous working directory

touch - change file timestamps
Used to create a new empty file and to change the
timestamps of existing files.
					   touch <FILE_NAME>
					
rm - remove
Remove files or directories
					   rm <FILE_NAME>
					   rm -rf <DIRECTORY_NAME>

man - Manual
An interface to the system reference manuals
					   man <COMMAND>
Note - use 'man level' to access our level manual


Press 'q' to exit the manual!

use rm - rf to delete the files after task completion
to keep your directory clean"

var npc_dialogue_scene = preload("res://Scenes/NPCDialogue.tscn")
var npc_dialogue
var dialogue_lines = [ "Welcome aboard, recruit! Today's your first day in The Grid, let us start from scratch.  Think of it like setting up your own base camp in this vast GRID.", 
"First things first, we must establish a base camp. That's where the mkdir command comes in. Imagine it like building your own digital cabin. You can use mkdir to create new directories (folders) to organize your stuff.",
"Now, with your base camp set up, we need to navigate around. That's where cd comes in. Think of it like a compass. You can use cd to change directories, moving from one location to another within The Grid.",
"But a base camp needs some basic resources, right? That's where touch comes in handy. You can use touch to create new empty files, like a digital notepad or a place to store your findings.",
"Alright, recruit! Use these commands to build your base camp and start getting familiar with the surroundings. Remember, a well-organized camp is a happy camp!"
 ]

var task_count = 3
var instructions = ["Create Day1 directory to organize files for Day1.", "Change into Day1 directory to work within it.", "Create file1, file2, and file3 for practice."]

var completed_tasks = []
var task_scene = load("res://Scenes/task.tscn")
var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()

func _ready():
	var terminal = $Terminal
	terminal.connect("check",self._on_check_pressed)
	user_reset()
	
	npc_dialogue = npc_dialogue_scene.instantiate()
	add_child(npc_dialogue)
	npc_dialogue.start_dialogue(dialogue_lines)
	
	var man_level = $Toolbar/WindowDialog/RichTextLabel
	man_level.text = level_manual
	
	var output = $RichTextLabel
	output.text += level_intro
	add_tasks()
	
func _on_dialogue_finished():
	pass

func add_tasks():
	var task
	var task_manager = $Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer
	for idx in task_count:
		task = task_scene.instantiate().duplicate()
		var instruction = task.get_node("HBoxContainer/Panel/RichTextLabel")
		instruction.text = instructions[idx]
		task_manager.add_child(task)
		task.position = Vector2(0, (task_manager.get_child_count() - 1) * 95)

func task1_status() -> bool:
	var dir = DirAccess.open("res://user")
	if dir.dir_exists("Day1"):
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/Day1"
	
func task3_status() -> bool:
	var commandline = $Terminal
	var required_files = ["file1", "file2", "file3"]
	var files_in_planet = commandline.execute("ls").split("\n")
	print(files_in_planet)
	for file in required_files:
		if file not in files_in_planet:
			return false
	return true
	
func update_status():
	var check_functions = [task1_status, task2_status, task3_status]
	for idx in task_count:
		print(completed_tasks)
		if idx + 1 not in completed_tasks:
			var task_manager = get_node("Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer")
			var task = task_manager.get_child(idx)
			var task_color = task.get_node("HBoxContainer/Panel/ColorRect")
			if check_functions[idx].call():
				task_color.color = Color(0,1,0)
				completed_tasks.append(idx + 1)
		
func _on_check_pressed():
	update_status()
	level_completed()
	
#CHECKING COMPLETION AND SAVING IN DICTIONARY
	
func is_level_completed() -> bool:
	return task1_status() and task2_status() and task3_status()

func level_completed():
	if is_level_completed():
		var congrats = $ConfirmationDialog
		congrats.popup_centered()
		var next = $Next
		next.visible = true
		var current_level = get_current_level()
		Save.save_progress(current_level)

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))
	
func _on_next_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")


func _on_confirmation_dialog_confirmed():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")

func user_reset():
	var output = []
	var error_code = OS.execute("wsl.exe", ["bash", "-c", "find -type d -name 'user'" ], output, true)
	if output[-1]:
		var deleting = OS.execute("wsl.exe", ["bash", "-c", "rm -rf user" ], output, true)
		var creating = OS.execute("wsl.exe", ["bash", "-c", "mkdir user" ], output, true)
		print("reset done")
	else:
		print("no")
	return String(output[-1])
