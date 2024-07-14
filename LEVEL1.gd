extends Node2D

var level_title = "The Journey Begins"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
func level_win_condition():
	return OS.execute("test", ["-d", "planet"]) == 0 and OS.execute("test", ["-f", "planet/resource1"]) == 0
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
const Terminal = preload("res://terminal.gd")
func setup_level():
	var terminal_instance = Terminal.new()
	for cmd in level_setup_commands:
		var response = terminal_instance.processCommand(cmd)

func check_win_condition() -> bool:
	return level_win_condition()

func show_congrats_message():
	var output = $output
	output.text += "\n" + level_congrats_message + "\n"


