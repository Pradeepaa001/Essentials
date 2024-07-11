extends Node2D

var input_enabled : bool = true
var entered: bool = false

#func _on_text_changed(new_text: String):
	#var cmd = get_node("Input")
	#print("new text is", new_text)
	#var response = processCommand(cmd)
	#var output = $Output
	#output.text += response + "\n"
	#entered = false
	##text_edit2.cursor_set_line(text_edit2.get_line_count())

func processCommand(cmd):
	var response: String = "\n"
	match str(cmd):
		"help":
			response += "Available commands: help - Display available commands ls - List files"
		"ls":
			response += "File1.txt\nFile2.txt"
		"":
			response = ""
		_:
			response += "Command not recognized: " + cmd
	return response

func _on_line_edit_text_submitted(cmd):
	
	get_node("Input")
	var response = processCommand(cmd) + "\n"
	var output = $output
	output.text += response
	entered = false

