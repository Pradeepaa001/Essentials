extends Node2D

var level_title = "The Master of files"
var level_description = "Welcome to the new planet captain! Now you are on a mission to fix the things here in order to help the aliens live a peaceful life.See around (ls), ask for help(ls --help) and find the hidden problems(ls -a). Dive in!"
var level_setup_commands = ["ls", "ls --help", "ls -a"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."

func _ready():
	var output = $RichTextLabel
	output.text += level_title + "\n"
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	output.text += level_description + "\nSetup commands:\n" + commands


func task1_status() -> bool:
	#print("4")
	var task1 = $Terminal
	var dir = DirAccess.open("res://user")
	#print("heh")
	if dir.dir_exists("planet"):
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/planet"
	
func task3_status() -> bool:
	var commandline = $Terminal
	var required_files = ["resource1", "resource2", "resource3"]
	var files_in_planet = commandline.execute("ls").split("\n")
	print(files_in_planet)
	for file in required_files:
		if file not in files_in_planet:
			return false
	return true
	
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

func _on_check_pressed():
	var output = $RichTextLabel
	update_icons()
	if task1_status() and task2_status() and task3_status():
		output.text += "\ntasks completed\n"
	else:
		output.text += "\ntasks are not completed\n"
