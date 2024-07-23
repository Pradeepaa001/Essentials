extends Node2D

var level_description = """\t\tThe Master of files
Learn to list the contents of a directory with ls commands.

Instructions:
1. Use `ls` to view the contents of a directory. Example: `ls`
2. Use `ls --help` to know how to use ls. Example: `ls --help`
3. Use `ls -a` to view hidden files. Example: `ls -a`
4. Use `ls *<char>` to view files and sub-directories that start with specified character. Example: `ls r*`
	note: This lists nothings if there are no contents starting with the character 
5. Use `pwd` to see the path of current working directory. Example: `rmdir data`
"""

var level_manual = "\nls - list directory contents
Lists all the files and directories under a specified directory. 
By default, ls uses the current directory and lists files and directories in alphabetical order by name.
					   ls <OPTION> <FILE_NAME>

OPTIONS:
	
	--help: display this help and exit
	
	-a:  do not ignore entries starting with .
	Hidden Files are prefixed with a period . and are called dot files.
	To include these hidden files, -a is used
	
ls *<char> - Lists files and sub-directories that start with specified character.
Note - Lists nothing if there are no contents starting with the character


rm - remove
Remove files or directories
					   rm <FILE_NAME>
					   rm -rf <DIRECTORY_NAME>

man - Manual
An interface to the system reference manuals
					   man <COMMAND>
Note - Use 'man level' to access our level manual


Press 'q' to exit the manual!

use rm - rf to delete the files after task completion
to keep your directory clean"

var dialogue_lines = ["Welcome to the level2!", "Use arrow keys to move.", "Good luck!"]

var npc_dialogue_scene = preload("res://Scenes/NPCDialogue.tscn")
var npc_dialogue

var task_count = 5
var instructions = ["ls", "ls --help", "ls -a", "ls r*", "pwd"]
var level_congrats_message = "Well done, Explorer! You've completed the first level"
@onready var termi = $Terminal
var all_inputs = []

var task_scene = load("res://Scenes/task.tscn")
var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()

func _ready():
	user_reset()
	npc_dialogue = npc_dialogue_scene.instantiate()
	add_child(npc_dialogue)
	
	npc_dialogue.start_dialogue(dialogue_lines)
	var man_level = $Toolbar/WindowDialog/RichTextLabel
	man_level.text = level_manual
	var output = $RichTextLabel
	output.text += level_description
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
	all_inputs = termi.get_input_list()
	return "ls" in all_inputs

func task2_status():
	all_inputs = termi.get_input_list()
	return "ls --help" in all_inputs

	
func task3_status() -> bool:
	all_inputs = termi.get_input_list()
	return "ls -a" in all_inputs
	
func task4_status() -> bool:
	all_inputs = termi.get_input_list()
	for commands in all_inputs:
		if "ls " and "*" in commands:
			return true
	return false
	
func task5_status() -> bool:
	all_inputs = termi.get_input_list()
	return "pwd" in all_inputs
	
func update_status():
	var check_functions = [task1_status, task2_status, task3_status, task4_status, task5_status]
	for idx in task_count:
		var task_manager = get_node("Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer")
		var task = task_manager.get_child(idx)
		var task_color = task.get_node("HBoxContainer/Panel/ColorRect")
		task_color.color = Color(0,1,0) if check_functions[idx].call() else Color(1,0,0)

func _on_check_pressed():
	update_status()
	level_completed()

func is_level_completed() -> bool:
	return task1_status() and task2_status() and task3_status() and task3_status() and task4_status() and task5_status()

func level_completed():
	if is_level_completed():
		var current_level = get_current_level()
		Save.save_progress(current_level)

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))
	

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
