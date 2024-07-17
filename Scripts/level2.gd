extends Node2D

var level_title = "Advanced Shell Scripting"
var level_description = "In this level, you will dive deeper into shell scripting by learning how to use special variables and command substitution. You'll understand how to handle script arguments, capture command outputs, and utilize return codes for conditional execution."
var level_congrats_message = "Great job! You've mastered advanced shell scripting concepts."
const Terminal = preload("res://Scripts/terminal.gd")

var filesystem = {"/": {}}
var current_path = "/"

func _ready():
	$RichTextLabel.bbcode_text = level_description

func check_win_condition() -> bool:
	return "advanced_script.sh" in filesystem["/"]

func show_congrats_message():
	var output = $TextEdit
	output.text += "\n" + level_congrats_message + "\n"

func _on_LineEdit_text_submitted(cmd: String):
	var response = processCommand(cmd) + "\n"
	$TextEdit.text += response
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
		"touch":
			if parts.size() > 1:
				var dir_ref = get_current_dir()
				for i in range(1, parts.size()):
					dir_ref[parts[i]] = ""
				response += "Files created: " + ", ".join(parts.slice(1))
			else:
				response += "touch: missing file operand"
		"ls":
			var dir_ref = get_current_dir()
			if dir_ref:
				response += "\n".join(dir_ref.keys())
			else:
				response += "No files found"
		"echo":
			if parts.size() > 1:
				response += " ".join(parts.slice(1))
			else:
				response += ""
		"cat":
			if parts.size() > 1:
				var dir_ref = get_current_dir()
				var file_name = parts[1]
				if file_name in dir_ref:
					response += "Content of " + file_name
				else:
					response += "cat: " + file_name + ": No such file or directory"
			else:
				response += "cat: missing file operand"
		_:
			response += "Unknown command: " + parts[0]

	return response
