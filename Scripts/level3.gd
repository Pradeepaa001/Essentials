extends Node2D

var level_title = "File and Directory Management"
var level_description = """
Explore the files and directories on your spaceship. Learn to list, view, move, copy, and remove files and directories.

Instructions:
1. Use `cat` to view the contents of a file. Example: `cat file1`
2. Use `mv` to move or rename a file. Example: `mv file1 backup/`
3. Use `cp` to copy a file. Example: `cp file2 backup/`
4. Use `rm` to remove a file. Example: `rm file3`
5. Use `rmdir` to remove an empty directory. Example: `rmdir data`
"""

var level_setup_commands = [
	"mkdir data",
	"cd data",
	"touch file1 file2 file3",
	"echo 'This is file1' > file1",
	"echo 'This is file2' > file2",
	"echo 'This is file3' > file3",
	"cd ..",
	"mkdir backup"
]
var level_congrats_message = "Great job! You've mastered basic file and directory management."

func _ready():
	var output = $RichTextLabel
	output.text = level_title + "\n" + level_description + "\n"

func task1_status() -> bool:
	var dir = DirAccess.open("res://user")
	if dir.dir_exists("data") and dir.dir_exists("backup"):
		print('yes')
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/data"
	
func task3_status() -> bool:
	var commandline = $Terminal
	var required_files = ["file1", "file2", "file3"]
	var files_in_data = commandline.execute("ls data").split("\n")
	for file in required_files:
		if file not in files_in_data:
			return false
	return true

func task4_status() -> bool:
	var commandline = $Terminal
	var files_in_backup = commandline.execute("ls backup").split("\n")
	return "file1" in files_in_backup and "file2" in files_in_backup

func task5_status() -> bool:
	var commandline = $Terminal
	var files_in_data = commandline.execute("ls data").split("\n")
	return "file3" not in files_in_data

func task6_status() -> bool:
	var commandline = $Terminal
	var dir = DirAccess.open("res://user")
	return not dir.dir_exists("data")

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
		
	if task6_status():
		$ColorRect6.color = Color(0, 1, 0)
	else:
		$ColorRect6.color = Color(1, 0, 0)

func _on_check_button_pressed():
	var output = $RichTextLabel
	print('1')
	update_icons()
	print('2')
	if task1_status() and task2_status() and task3_status() and task4_status() and task5_status() and task6_status():
		output.text += "\nAll tasks completed\n" + level_congrats_message
		output.text += "All Tasks Completed"
	else:
		output.text += "\nTasks are not completed\n"
		output.text += "Check Status"
