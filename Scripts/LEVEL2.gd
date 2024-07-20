extends Node2D

var level_title = "The Master of files"
var level_description = "Welcome to the new planet captain! Now you are on a mission to fix the things here in order to help the aliens live a peaceful life.See around (ls), ask for help(ls --help) and find the hidden problems(ls -a). Dive in!"
var level_setup_commands = ["ls", "ls --help", "ls -a"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
@onready var termi = $Terminal
var all_inputs = []


func _ready():
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
	print("check is pressed")
	update_icons()
	if task1_status() and task2_status() and task3_status():
		output.text += "\ntasks completed\n"
	else:
		output.text += "\ntasks are not completed\n"
