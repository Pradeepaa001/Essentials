extends Node2D
var level_setup_commands = "mkdir data && cd data && touch tasks info agents && echo 'learn shell' > tasks && echo 'Missing semester is a good idea' > info && echo 'You are Agent 101' > agents && mkdir dont_open && touch risk"
var level_description = """\t\tMaster of Shell Commands
Learn to use various shell commands like cat, mv, cp, rm, and rmdir.

Instructions:
1. Use `cat` to view the contents of a file. Example: `cat tasks`
2. Use `mv` to move or rename a file. Example: `mv tasks new_tasks`
3. Use `cp` to copy a file. Example: `cp new_tasks backup_tasks`
4. Use `rm` to remove a file. Example: `rm backup_tasks`
5. Use `rmdir` to remove a directory. Example: `rmdir dont_open`

Note: Be careful with `rm` and `rmdir` as they permanently delete files and directories.
"""

var level_manual = """
cat - concatenate and display files
View the contents of a file.
Usage: cat <FILE_NAME>

mv - move (rename) files
Move or rename a file or directory.
Usage: mv <SOURCE> <DESTINATION>

cp - copy files and directories
Copy files or directories.
Usage: cp <SOURCE> <DESTINATION>

rm - remove files or directories
Remove files or directories.
Usage: rm <FILE_NAME>
	   rm -r <DIRECTORY_NAME>

rmdir - remove empty directories
Remove empty directories.
Usage: rmdir <DIRECTORY_NAME>

man - Manual
An interface to the system reference manuals
Usage: man <COMMAND>

Press 'q' to exit the manual!
"""

var dialogue_lines = ["Howdy, partner! Welcome to Level 3.", 
"Today's your first day on the organization department, and things are a bit of a mess. Files are scattered everywhere like tumbleweeds in a dust storm!", 
"But fear not, rookie! Let us learn how to work around the mess with some essential commands.", 
"First up, we got the 'cat' command. Think of it like a brand new pair of spectacles. You can use cat to peek inside files and see what they hold",
"Now, sometimes files are in the wrong directory. That's where mv comes in. Think of it like your lasso. You can use mv to move files from one directory to another, putting them in their right place.",
"But what if you need a copy of a file in two locations at once?  No problem! We got cp for that. Just like a xerox, cp makes a duplicate of a file, leaving the original one untouched",
"Now, some files might be… well… beyond saving. Like something that is rotten. That's where rm comes in. Think of it as a shovel. You can use rm to get rid of unwanted files, but be careful! Once they're gone, they're gone for good.",
"Finally, sometimes we gotta clean up a whole empty directory. That's where rmdir comes in handy. You can use rmdir to remove empty directories, keeping things nice and tidy.",
"Alright, partner! Time to put on your skills to test. Use the commands wisely to organize your directory!"]

var npc_dialogue_scene = preload("res://Scenes/NPCDialogue.tscn")
var npc_dialogue

var completed_tasks = [] 
var task_count = 5
var instructions = ["cat tasks", "mv tasks new_tasks", "cp new_tasks backup_tasks", "rm backup_tasks", "rmdir dont_open"]
var level_congrats_message = "Well done, Explorer! You've completed level 3"
@onready var termi = $Terminal
var all_inputs = []

var task_scene = load("res://Scenes/task.tscn")
var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()

func _ready():
	termi.connect("check",_on_check_pressed)
	termi.execute(level_setup_commands)
	termi.pwd = "user/data"
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

func check_contents() -> String:
	var op =[]
	var command_exec = OS.execute("wsl.exe", ["bash", "-c", "cd " + termi.pwd + "&& " + "ls"], op, true)
	print(String(op[-1]))
	return String(op[-1])

func task1_status() -> bool:
	all_inputs = termi.get_input_list()
	var op = check_contents()
	return "tasks" in op and "cat tasks" in all_inputs

func task2_status() -> bool:
	all_inputs = termi.get_input_list()
	var op = termi.execute("ls")
	return ("new_tasks" in op) and ("\ntasks\n" not in op) and ("mv tasks new_tasks" in all_inputs)
	
	
func task3_status() -> bool:
	all_inputs = termi.get_input_list()
	var op = check_contents()
	return ("new_tasks" in op) and ("backup_tasks" in op) and ("cp new_tasks backup_tasks" in all_inputs)
	
func task4_status() -> bool:
	all_inputs = termi.get_input_list()
	var op =check_contents()
	return "backup_tasks" not in op and "rm backup_tasks" in all_inputs
	
func task5_status() -> bool:
	all_inputs = termi.get_input_list()
	var op =check_contents()
	return "dont_open" not in op and "rmdir dont_open" in all_inputs
	
func update_status():
	var check_functions = [task1_status, task2_status, task3_status, task4_status, task5_status]
	for idx in task_count:
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

func is_level_completed() -> bool:
	#return task1_status() and task2_status() and task3_status() and task4_status() and task5_status()
	return completed_tasks.size() == task_count
	

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
	get_tree().change_scene_to_file("res://Scenes/level_4.tscn")


func _on_confirmation_dialog_confirmed():
	get_tree().change_scene_to_file("res://Scenes/level_4.tscn")

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
