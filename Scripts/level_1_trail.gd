extends Node2D

var level_title = "The Journey Begins"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
const Terminal = preload("res://Scripts/terminal.gd")
var terminal = Terminal.new()

func _ready():
	var output = $TextEdit
	output.text += level_title + "\n"
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	output.text += level_description + "\nSetup commands:\n" + commands

func task1_status() -> bool:
	print("4")
	var dir = DirAccess.open("res://user")
	print("heh")
	if dir.dir_exists("planet"):
		return true
	else:
		return false

func task2_status():
	var commandline = $Terminal
	return commandline.pwd == "user/planet"
	
func task3_status() -> bool:
	print("h m")
	var required_files = ["resource1", "resource2", "resource3"]
	var files_in_planet = terminal.execute(["ls", "\\user/planet"]).split("\n")
	print(files_in_planet)
	for file in required_files:
		print(file)
		if file not in files_in_planet:
			return false
	return true

func _on_button_pressed():
	Color.ALICE_BLUE
	print("yesss")
	var output = $TextEdit
	if task1_status() and task2_status() and task3_status():
		output.text += "\ntasks completed\n"
	else:
		output.text += "\ntasks are not completed\n"
		Color.RED
