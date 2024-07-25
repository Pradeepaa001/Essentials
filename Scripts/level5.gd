extends Node2D

var level_setup_commands = "mkdir data && cd data && echo 'This is file1' > file1 && echo 'This is file2' > file2 && echo 'This is file3' > file3 && mkdir test_dir"

var level_description = """\t\tMaster of File Viewing and Disk Usage
Learn to use various shell commands like tail, head, more, du, and echo.

Instructions:
1. Use `tail` to display the last part of a file. Example: `tail file1`
2. Use `head` to display the first part of a file. Example: `head file2`
3. Use `more` to view the contents of a file page by page. Example: `more file3`
4. Use `du` to check the disk usage of a directory. Example: `du -sh data`
5. Use `echo` to print text to the terminal. Example: `echo "Hello, World!"`

Note: `tail` and `head` can be used with options to customize the output.
"""

var level_manual = """
tail - output the last part of files
Display the last part of a file. Useful for viewing the end of large files.
Usage: tail <FILE_NAME>

head - output the first part of files
Display the first part of a file. Useful for viewing the beginning of files.
Usage: head <FILE_NAME>

more - view file contents interactively
View the contents of a file one page at a time.
Usage: more <FILE_NAME>

du - disk usage
Estimate file space usage. Show the size of files and directories.
Usage: du <OPTION> <DIRECTORY>
Options:
	-sh: Display the total size in a human-readable format.

echo - display a line of text
Print text or variables to the terminal.
Usage: echo <TEXT>

man - Manual
An interface to the system reference manuals
Usage: man <COMMAND>

Press 'q' to exit the manual!
"""

var dialogue_lines = [
"Great to see you, intern! Welcome to Level 5! Today, let us learn how to analyze and understand the vast amount of information stored within The Grid.",
"First up, the tail command. Think of it like reading the last page of a old book. You can use tail to peek at the final lines of a file, to check what is happening at the end.",
"However, sometimes, the beginning holds the key. That's where 'head' comes in. Imagine it like flipping to the first page of a old book. You can use head to view the initial lines of a file, uncovering the first bits of information.",
"Now, some files can be really big, like a never-ending scroll. That's where 'more' comes in handy. Think of it like a handy scroll reader. You can use more to navigate through a long file one screen at a time.",
"But sometimes, information overload can be a real problem. That's where du steps in. Imagine it like a digital weigh machine. You can use du to see how much disk space each file or directory is using.",
"And for an extra bit of clarity, we have du -sh. Think of it like the same machine with a conversion chart. You can use du -sh to display disk usage in a human-readable format, like megabytes or gigabytes.",
"Last but not least, we have the echo command. Think of it like a digital megaphone. You can use echo to display messages on the screen, create custom banners, or even send text to other programs.",
"Alright, partner! Use these commands to explore files, manage information overload, and create your own messages within The Grid!"]

var npc_dialogue_scene = preload("res://Scenes/NPCDialogue.tscn")
var npc_dialogue

var task_count = 5
var instructions = ["tail file1", "head file2", "more file3", "du -sh data", 'echo "Hello World!"']
var level_congrats_message = "Well done, Explorer! You've completed level 5"
@onready var termi = $Terminal
var all_inputs = []
var completed_tasks = [] 
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

func task1_status() -> bool:
	all_inputs = termi.get_input_list()
	return "tail file1" in all_inputs

func task2_status() -> bool:
	all_inputs = termi.get_input_list()
	return "head file2" in all_inputs
	
func task3_status() -> bool:
	all_inputs = termi.get_input_list()
	return "more file3" in all_inputs
	
func task4_status() -> bool:
	all_inputs = termi.get_input_list()
	return "du -sh data" in all_inputs
	
func task5_status() -> bool:
	all_inputs = termi.get_input_list()
	return 'echo "Hello World!"' in all_inputs
	
func update_status():
	var check_functions = [task1_status, task2_status, task3_status, task4_status, task5_status]
	for idx in task_count:
		if idx + 1 in completed_tasks:
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
	return task1_status() and task2_status() and task3_status() and task4_status() and task5_status()

func level_completed():
	if is_level_completed():
		var congrats = $ConfirmationDialog
		congrats.popup_centered()
		var next = $next
		next.visible = true
		var current_level = get_current_level()
		Save.save_progress(current_level)

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))
	

func _on_next_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_6.tscn")


func _on_confirmation_dialog_confirmed():
	get_tree().change_scene_to_file("res://Scenes/level_6.tscn")

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
