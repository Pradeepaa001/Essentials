extends Node2D

var level_title = "The Master of files"
var level_description = """
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



var level_setup_commands = ["ls", "ls --help", "ls -a", "ls r*", "pwd"]
var level_congrats_message = "Well done, Explorer! You've completed the first level"
@onready var termi = $Terminal
var all_inputs = []


func _ready():
	var man_level = $Toolbar/WindowDialog/RichTextLabel
	man_level.text = level_manual
	var output = $RichTextLabel
	print("started")
	output.text += level_title + "\n"
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	output.text += level_description + "\nSetup commands:\n" + commands


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
	
func update_icons():
	if task1_status():
		$ColorRect1.color  = Color(0,1,0)
		print("task1:", task1_status())

	else:

		$ColorRect1.color  = Color(1,0,0)
		print("task1:", task1_status())

		

	if task2_status():
		print("task2:", task2_status())
		$ColorRect2.color  = Color(0,1,0)

	else:

		$ColorRect2.color  = Color(1,0,0)
		print("task2:", task2_status())

	
	if task3_status():
		print("task3:", task3_status())
		$ColorRect3.color  = Color(0,1,0)

	else:
		print("task3:", task3_status())
		$ColorRect3.color  = Color(1,0,0)
	
	if task4_status():
		print("task3:", task4_status())
		$ColorRect4.color  = Color(0,1,0)

	else:
		print("task3:", task4_status())
		$ColorRect4.color  = Color(1,0,0)
	
	if task5_status():
		print("task3:", task5_status())
		$ColorRect.color  = Color(0,1,0)

	else:
		print("task3:", task5_status())
		$ColorRect.color  = Color(1,0,0)

func _on_check_pressed():
	var output = $RichTextLabel
	print("check is pressed")
	update_icons()
	if task1_status() and task2_status() and task3_status():
		output.text += "\ntasks completed\n"
	else:
		output.text += "\ntasks are not completed\n"
