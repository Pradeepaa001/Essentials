extends Node2D

var level_title = "The Journey Begins"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
const Terminal = preload("res://Scripts/terminal.gd")

var filesystem = {}

func _ready():
	$RichTextLabel.bbcode_text = level_description + "\nSetup commands:\n" + level_setup_commands.join("\n")
	setup_level()

func setup_level():
	for cmd in level_setup_commands:
		var response = processCommand(cmd)
		$TextEdit.append_text(response + "\n")

func check_win_condition() -> bool:
	return "planet" in filesystem and "resource1" in filesystem["planet"]

func show_congrats_message():
	var output = $TextEdit
	output.append_text("\n" + level_congrats_message + "\n")

func _on_line_edit_text_submitted(new_text: String):
	var response = processCommand(new_text) + "\n"
	$TextEdit.append_text(response)
	$LineEdit.text = ""
	if check_win_condition():
		show_congrats_message()

func processCommand(cmd: String) -> String:
	var response: String = "\n"
	var command = cmd.strip_edges().split(" ")

	match command[0]:
		"help":
			response += "Available commands: help - Display available commands, ls - List files, mkdir - Create directory, cd - Change directory, touch - Create file"
		"ls":
			if command.size() > 1 and command[1] in filesystem:
				var files = Array(filesystem[command[1]].keys())
				response += "\n" + files.join("\n")
			else:
				var dirs = Array(filesystem.keys())
				response += "\n" + dirs.join("\n")
		"mkdir":
			if command.size() > 1:
				filesystem[command[1]] = {}
				response += "Directory " + command[1] + " created."
			else:
				response += "mkdir: missing operand"
		"cd":
			# handle change directory logic
			pass
		"touch":
			if command.size() > 1:
				var parent_dir = filesystem["planet"]
				for i in range(1, command.size()):
					parent_dir[command[i]] = {}
				response += "Files " + command.slice(1, command.size()).join(", ") + " created."
			else:
				response += "touch: missing file operand"
		_:
			response += "Command not found: " + command[0]

	return response




