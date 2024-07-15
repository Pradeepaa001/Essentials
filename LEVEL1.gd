extends Node2D

var level_title = "The Journey Begins"
var level_description = "Welcome to the command line! Imagine you're a space explorer navigating through different directories (planets). Learn the basic commands to get around."
var level_setup_commands = ["mkdir planet", "cd planet", "touch resource1 resource2 resource3"]
var level_congrats_message = "Well done, Explorer! You've gathered your first resources."
const Terminal = preload("res://Scripts/terminal.gd")

var filesystem = {"/": {}}
var current_path = "/"

func _ready():
	var commands = ""
	for element in level_setup_commands:
		commands += str(element) + "\n"
	$RichTextLabel.bbcode_text = level_description + "\nSetup commands:\n" + commands

func check_win_condition() -> bool:
	return "planet" in filesystem["/"] and "resource1" in filesystem["/"]["planet"] and "resource2" in filesystem["/"]["planet"] and "resource3" in filesystem["/"]["planet"]

func show_congrats_message():
	var output = $TextEdit
	output.text = "\n" + level_congrats_message + "\n"

func _on_line_edit_text_submitted(cmd: String):
	var response = processCommand(cmd) + "\n"
	$TextEdit.text += response + '\n'
	$LineEdit.text = ""
	if check_win_condition():
		show_congrats_message()

func get_current_dir() -> Dictionary:
	var dirs = current_path.strip_edges().split("/")
	var dir_ref = filesystem["/"]
	for dir in dirs:
		if dir != "":
			dir_ref = dir_ref[dir]
	return dir_ref

func processCommand(cmd: String) -> String:
	var response: String = "\n"
	var parts = cmd.strip_edges().split(" ")

	match parts[0]:
		"mkdir":
			if parts.size() > 1:
				var dir_name = parts[1]
				var dir_ref = get_current_dir()
				if not dir_name in dir_ref:
					dir_ref[dir_name] = {}
					response += "Directory created: " + dir_name
				else:
					response += "Directory already exists: " + dir_name
			else:
				response += "mkdir: missing operand"
		"cd":
			if parts.size() > 1:
				var dir_name = parts[1]
				if dir_name == "..":
					var path_parts = current_path.strip_edges().split("/")
					if path_parts.size() > 1:
						current_path = "/" + "/".join(path_parts.slice(0, path_parts.size() - 1))
					else:
						current_path = "/"
					response += "Moved to parent directory"
				else:
					var dir_ref = get_current_dir()
					if dir_name in dir_ref:
						current_path = (current_path + "/" + dir_name).replace("//", "/")
						response += "Changed directory to: " + dir_name
					else:
						response += "cd: no such file or directory: " + dir_name
			else:
				response += "cd: missing operand"
		"touch":
			if parts.size() > 1:
				var dir_ref = get_current_dir()
				for i in range(1, parts.size()):
					dir_ref[parts[i]] = ""
				response += "Files created: " + ", ".join(parts.slice(1))
			else:
				response += "touch: missing file operand"
		"help":
			response += "Available commands: help - Display available commands, ls - List files, mkdir - Create directory, cd - Change directory, touch - Create file, pwd - Print working directory"
		"ls":
			var dir_ref = get_current_dir()
			if dir_ref:
				response += "\n".join(dir_ref.keys())
			else:
				response += "No files found"
		"pwd":
			response += current_path
		_:
			response += "Unknown command: " + parts[0]

	return response






