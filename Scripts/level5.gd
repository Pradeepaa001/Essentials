extends Node2D

var level_title = "Advanced File Commands"
var level_description = """
Learn advanced file commands on your spaceship. Master the usage of du, ln, ln -s, locate, and echo commands.

Instructions:
1. Use `du` to check the disk usage of a directory. Example: `du -sh data`
2. Use `ln` to create a hard link. Example: `ln file1 hardlink1`
3. Use `ln -s` to create a symbolic link. Example: `ln -s file2 symlink2`
4. Use `locate` to find a file by name. Example: `locate file3`
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

func _ready():
	var output = $RichTextLabel
	output.text = level_title + "\n" + level_description + "\n"

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
