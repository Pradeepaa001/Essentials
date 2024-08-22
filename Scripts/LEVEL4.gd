extends Node2D

var level_setup_commands = "printf 'ADD SUBTRACT MULTIPLY DIVIDE\nThe basic arithmetic operations are essential for everyday calculations. Addition combines two or more numbers to get a sum.\nSubtraction finds the difference between two numbers by taking one away from the other.\nMultiplication involves repeated addition of a number as many times as specified by another number.\nDivision splits a number into equal parts, determining how many times one number is contained within another.\nThese operations form the foundation for more complex mathematical concepts.\nThey are used in various fields, from simple budgeting to advanced engineering.\nUnderstanding these operations is crucial for solving real-world problems efficiently.
 ' > maths1 && mkdir data_folder"
var all_inputs = []
var level_intro = """\t\tThe Scripting Wizard
Agent 101 you are assigned with searching and sorting in files today. 
According to Shelldon, using grep, sort, wc, cut will help you.
For further help find level manual under Help.
Refer to the task manager to complete your tasks. """

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
Ex. cut -f 5 -d ',' file.txt

**man - manual**
An interface to the system reference manuals.
					   man <COMMAND>
Note: Use 'man level' to access our level manual.

Press 'q' to exit the manual!

Use `rm -rf` to delete files after task completion to keep your directory clean.
"


var npc_dialogue_scene = preload("res://Scenes/NPCDialogue.tscn")
var npc_dialogue
var dialogue_lines = [ 
"Welcome back, recruit! Let us begin with Level 4. The Grid holds mountains of data, but sometimes you need that specific needle in a haystack. Today, we'll learn powerful tools to navigate this information overload.", 
"Feeling lost in a sea of text? We have grep, your digital metal detector! Use grep to search through files for lines containing a specific pattern. grep has some more options, check them out in the help option.",
"Alright, found your data! Now, to organize it, let’s use sort. sort arranges lines of text in a specific order, alphabetical or numerical. sort has more options, check them out in the help option.",
"Now, let's get a headcount! Use wc to get a quick count of lines, words, and characters within a file. wc has some more options which can be used for more precise result, check them out in the help option.",
"Finally, to extract specific information! Use cut like a digital pair of scissors for your data! cut allows you to extract specific sections from a line of text. cut has more options, choose the right option for clean and accurate results. Find them in the help option.",
"Alright, recruit! Use these commands to navigate The Grid's data, organize it effectively, and extract the specific information you need!"
 ]


var task_count = 4
var finished = false 
var instructions = ["Search for 'ADD' in the file 'maths1'", "Sort the lines of text in the file 'maths1'", "Count the lines, words, characters in file 'maths1'", "Extract 2nd field from your file 'maths1' with delimiter as space"]
@onready var termi = $Terminal
var task_scene = load("res://Scenes/task.tscn")
var SaveSystem = preload("res://SaveSystem.gd")
var Save = SaveSystem.new()
var completed_tasks = []

func add_tasks():
	var task
	var task_manager = $Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer
	for idx in range(task_count):
		task = task_scene.instantiate().duplicate()
		var instruction = task.get_node("HBoxContainer/Panel/RichTextLabel")
		instruction.text = instructions[idx]
		task_manager.add_child(task)
		task.position = Vector2(0, (task_manager.get_child_count() - 1) * 95)

func _ready():
	termi.connect("check",_on_check_pressed)
	
	npc_dialogue = npc_dialogue_scene.instantiate()
	add_child(npc_dialogue)
	npc_dialogue.start_dialogue(dialogue_lines)
	
	termi.execute(level_setup_commands)
	var man_level = $Toolbar/WindowDialog/RichTextLabel
	man_level.text = level_manual
	var output = $RichTextLabel
	output.text += level_intro
	add_tasks()

@onready var commandline = $Terminal	
func task1_status() -> bool:
	all_inputs = commandline.get_input_list()
	for commands in all_inputs:
		if "grep " in commands and "'ADD' " in commands and "maths1" in commands:
			return true
	return false

func task2_status() -> bool:
	all_inputs = commandline.get_input_list()
	for commands in all_inputs:
		if "sort " in commands and "maths1" in commands:
			return true
	return false

func task3_status() -> bool:
	all_inputs = commandline.get_input_list()
	return "wc maths1" in all_inputs


func task4_status() -> bool:
	all_inputs = commandline.get_input_list()
	return "cut -f 2 -d ' ' maths1" in all_inputs

func update_status():
	var task_count = 4
	var check_functions = [task1_status, task2_status, task3_status, task4_status]
	
	for idx in range(task_count):
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
	return task1_status() and task2_status() and task3_status() and task4_status()

func level_completed():
	if is_level_completed():
		if !finished:
			var congrats = $ConfirmationDialog
			congrats.popup_centered()
			finished = true
		var next = $next
		next.visible = true
		var current_level = get_current_level()
		Save.save_progress(current_level)

func get_current_level() -> int:
	var scene_name = get_tree().current_scene.name
	return int(scene_name.replace("level_", "").replace(".tscn", ""))



func user_reset():
	var output = []
	var error_code = OS.execute("wsl.exe", ["bash", "-c", "find -type d -name 'user'"], output, true)
	if output[-1]:
		OS.execute("wsl.exe", ["bash", "-c", "rm -rf user"], output, true)
		OS.execute("wsl.exe", ["bash", "-c", "mkdir user"], output, true)
		print("reset done")
	else:
		print("no")
	return String(output[-1])


func _on_confirmation_dialog_confirmed():
	get_tree().change_scene_to_file("res://Scenes/level_5.tscn")


func _on_next_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_5.tscn")



