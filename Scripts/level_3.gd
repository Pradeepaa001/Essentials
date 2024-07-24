extends Node2D

var level_title = "File and Directory Management"
var level_description = """
Explore the files and directories on your spaceship. Learn to list, view, move, copy, and remove files and directories.

Instructions:
1. Use `cat` to view the contents of a file. Example: `cat file1`
2. Use `mv` to move or rename a file. Example: `mv file1 backup/`
3. Use `cp` to copy a file. Example: `cp file2 backup/`
4. Use `rm -rf` to remove a directory. Example: `rmdir data`
"""

var level_congrats_message = "Great job! You've mastered basic file and directory management."
var task_count = 9
var task_scene = load("res://Scenes/task.tscn")
var instructions = ["mkdir data",
	"cd data",
	"touch file1 file2",
	"echo 'This is file1' > file1",
	"cat file1",
	"cp file1 task6 ",
	"mv file2 task7",
	"mkdir backup", 
	"rm -rf backup"]
func _ready():
	user_reset()
	var output = $RichTextLabel
	output.text = level_title + "\n" + level_description + "\n" 
	add_tasks()

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
	if dir.dir_exists("data"):
		print('yes')
		return true
	else:
		print("false")
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/data"
	
func task3_status() -> bool:
	var commandline = $Terminal
	var required_files = ["file1", "file2"]
	var files_in_data = commandline.execute("ls data").split("\n")
	for file in required_files:
		if file not in files_in_data:
			return false
	return true

func task4_status() -> bool:
	var commandline = $Terminal
	var files_content = commandline.execute("cat file1").split("\n")
	return 'This is file1' in files_content

func task5_status() -> bool:
	var commandline = $Terminal
	var files_in_data = commandline.execute("ls data").split("\n")
	return "file3" not in files_in_data

func task6_status() -> bool:
	var commandline = $Terminal
	var dir = DirAccess.open("res://user")
	return not dir.dir_exists("data")


func update_status():
	var check_functions = [task1_status, task2_status, task3_status, task4_status, task5_status]
	for idx in task_count:
		var task_manager = get_node("Task_manager/BoxContainer/Panel/ScrollContainer/VBoxContainer")
		var task = task_manager.get_child(idx)
		var task_color = task.get_node("HBoxContainer/Panel/ColorRect")
		task_color.color = Color(0,1,0) if check_functions[idx].call() else Color(1,0,0)

func _on_check_button_pressed():
	var output = $RichTextLabel
	print('1')
	#update_icons()
	print('2')
	update_status()
	if task1_status() and task2_status() and task3_status() and task4_status() and task5_status() and task6_status():
		output.text += "\nAll tasks completed\n" + level_congrats_message
		output.text += "All Tasks Completed"
	else:
		output.text += "\nTasks are not completed\n"
		output.text += "Check Status"
		
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
