extends Node2D

var entered: bool = false


func processCommand(cmd: String) -> String:
	var response: String = "\n"
	
	if cmd.strip_edges() in ["help", "ls"]:
		match cmd.strip_edges():
			"help":
				response += "Available commands: help - Display available commands, ls - List files"
			"ls":
				response += "File1.txt\nFile2.txt"
	else:
		var output = []
		var command = cmd.split(" ")
		var output_buffer = PackedStringArray()
		var error_buffer = PackedStringArray()
		#var error_code = helpers.exec(cmd)
		var error_code = OS.execute("wsl.exe",command, output, true)
		#var error_code = helpers.exec()
		print(output)
		if error_code == 0:
			response += String(output[-1])
		else:
			response += "Command failed with error code: " + str(error_code) + "\n" + String(output[-1])

	
	return response

func _on_line_edit_text_submitted(cmd: String):
	var input = get_node("Input")
	var response = processCommand(cmd) + "\n"
	var output = $output
	output.text += response
	input.text = clear(input.text)
	entered = false


func clear(input):
	input = ""
	return input
