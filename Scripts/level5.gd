extends Node2D

var level_title = "Advanced File Commands"
var level_description = """
Learn advanced file commands on your spaceship. Master the usage of du, ln, ln -s, locate, and echo commands.

Instructions:
1. Use `tail` to display the last part of a file. Example: `tail file1`
2. Use `head` to display the first part of a file. Example: `head file2`
3. Use `more` to view the contents of a file page by page. Example: `more file3`
4. Use `du` to check the disk usage of a directory. Example: `du -sh data`
5. Use `echo` to print text to the terminal. Example: `echo "Hello, World!"`
"""

var level_setup_commands = [
	"mkdir data",
	"cd data",
	"touch file1 file2 file3",
	"echo 'This is file1' > file1",
	"echo 'This is file2' > file2",
	"echo 'This is file3' > file3",
	"cd ..",
	"updatedb" 
]
var level_congrats_message = "Great job! You've mastered advanced file commands."
var task_count = 5
var task_scene = load("res://Scenes/task.tscn")
var instructions = ["mkdir data",
	"cd data",
	"touch file1 file2 file3",
	"echo 'This is file1' > file1",
	"echo 'This is file2' > file2",
	"echo 'This is file3' > file3",
	"cd ..",
	"mkdir backup"]
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
	var commandline = $Terminal
	var du_output = commandline.execute("du -sh data").split("\t")
	if du_output.size() == 2 and du_output[1].strip_edges() == "data":
		return true
	return false

func task2_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("ls").find("hardlink1") != -1

func task3_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("ls").find("symlink2") != -1

func task4_status() -> bool:
	var commandline = $Terminal
	return commandline.execute("locate file3").find("data/file3") != -1

func task5_status() -> bool:
	var commandline = $Terminal
	var echo_output = commandline.execute("echo 'Hello, World!'").strip_edges()
	return echo_output == "Hello, World!"

func update_icons():
	if task1_status():
		$ColorRect1.color = Color(0, 1, 0)
	else:
		$ColorRect1.color = Color(1, 0, 0)
		
	if task2_status():
		$ColorRect2.color = Color(0, 1, 0)
	else:
		$ColorRect2.color = Color(1, 0, 0)

	if task3_status():
		$ColorRect3.color = Color(0, 1, 0)
	else:
		$ColorRect3.color = Color(1, 0, 0)

	if task4_status():
		$ColorRect4.color = Color(0, 1, 0)
	else:
		$ColorRect4.color = Color(1, 0, 0)
		
	if task5_status():
		$ColorRect5.color = Color(0, 1, 0)
	else:
		$ColorRect5.color = Color(1, 0, 0)

func _on_check_button_pressed():
	var output = $RichTextLabel
	update_icons()
	if task1_status() and task2_status() and task3_status() and task4_status() and task5_status():
		output.text += "\nAll tasks completed\n" + level_congrats_message
	else:
		output.text += "\nTasks are not completed\n"

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
