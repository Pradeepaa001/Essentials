extends Node2D

var level_intro = "STORY
Refer to the task manager to find your tasks.
Find your level manual in the help section of your toolbar.
You can use the Level Manual to finish your tasks"

var level_congrats_message = "Well done, Explorer!"

var level_manual = "\n**grep - search text using patterns**
Search for patterns in files and display matching lines.
					   grep <PATTERN> <FILE_NAME>
Options:
- `-i`: Case-insensitive search.
- `-w`: Match whole words only.
- `-r`: Recursive search in directories.
- `-n`: Show line numbers.
- `-c`: Count matching lines.

**sort - sort lines of text files**
Sort lines in a text file.
					   sort <FILE_NAME>
Options:
- `-r`: Reverse the sort order.
- `-n`: Sort numerically.
- `-k`: Sort by a specific field.

**wc - word, line, character, and byte count**
Count lines, words, characters, or bytes in files.
					   wc <FILE_NAME>
Options:
- `-l`: Count lines.
- `-w`: Count words.
- `-m`: Count characters.
- `-c`: Count bytes.

**cut - remove sections from each line of files**
Remove sections from each line of files.
					   cut <OPTIONS> <FILE_NAME>
Options:
- `-f`: Select fields (columns).
- `-d`: Specify a delimiter (default is tab).

**man - manual**
An interface to the system reference manuals.
					   man <COMMAND>
Note: Use 'man level' to access our level manual.

Press 'q' to exit the manual!

Use `rm -rf` to delete files after task completion to keep your directory clean.
"

var task_count = 4
var instructions = ["Search for a pattern in the file created", "Sort the lines of text in the file for good organization", "Count the lines, words, characters in your file", "Remove specific columns from your file"]

var task_scene = load("res://Scenes/task.tscn")
var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()

func add_tasks():
	var task
	var task_manager = $Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer
	for idx in range(task_count):
		task = task_scene.instantiate().duplicate()
		var instruction = task.get_node("HBoxContainer/Panel/RichTextLabel")
		instruction.text = instructions[idx]
		task_manager.add_child(task)
		task.position = Vector2(0, (task_manager.get_child_count() - 1) * 95)

func add_content_to_file():
	var file = FileAccess.open("user://file1.txt", FileAccess.WRITE)
	var content = [
"Open Source: Freely accessible and modifiable code.",
"Linux Kernel: Core component, created by Linus Torvalds in 1991.",
"Distributions: Variants like Ubuntu, Fedora, Debian.",
"Command Line: Powerful CLI for task management.",
"Security: Less prone to viruses and malware.",
"Usage: Found in servers, supercomputers, Android, and embedded systems.",
"Community: Developed by a global community of contributors.",
"File Systems: Supports ext4, XFS, Btrfs, etc.",
"Package Management: Uses APT, RPM, Pacman for software.",
"Licensing: Under GNU GPL, requiring open-source derivatives.",
	]
	for line in content:
		file.store_line(line)
	file.close()
func task1_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("grep 'pattern' user://file1.txt")
	

func task2_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("sort user://file1.txt")


func task3_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("wc user://file1.txt")

func task4_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("cut -f1 user://file1.txt")


func update_status():
	var task_count = 4
	var check_functions = [task1_status, task2_status, task3_status, task4_status]
	
	for idx in range(task_count):
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
	return task1_status() and task2_status() and task3_status() and task4_status()

func level_completed():
	if is_level_completed():
		var current_level = get_current_level()
		Save.save_progress(current_level)

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))

func _ready():
	var man_level = $Toolbar/WindowDialog/RichTextLabel
	man_level.text = level_manual
	var output = $RichTextLabel
	output.text += level_intro
	add_tasks()
	add_content_to_file()
