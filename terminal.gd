extends Node2D


var input_enabled : bool = true

func _on_text_changed(new_text: String):

	

	var cmd = get_node("Input")

	var response = processCommand(cmd)
	
	var output = $Output
	output.text += response + "\n"
	#text_edit2.cursor_set_line(text_edit2.get_line_count())

func processCommand(cmd):
	var response = "\n"
	match cmd:
		"help":
			response += "Available commands:\n  help - Display available commands\n  ls - List files\n"
		"ls":
			response += "File1.txt\nFile2.txt"
		"":
			response = ""
		_:
			response += "Command not recognized: " + cmd
	return response


