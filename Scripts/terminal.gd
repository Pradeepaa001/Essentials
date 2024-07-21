extends Node

var pwd = "user"
var input_list = []
var curr = -1
signal man_level

func process_command(cmd: String) -> String:
	var response: String = "$" + cmd + "\n"
	var grey_list_commands = ["cd", "pwd", "clear", "man level"]
	var grey_list_processing = [self.process_cd, self.process_pwd, self.process_clear, self.process_manlevel]
	
	for idx in range(grey_list_commands.size()):
		if grey_list_commands[idx] in cmd:
			return response + grey_list_processing[idx].call(cmd) + "\n"
	
	return response + execute(cmd) + "\n"

func execute(cmd):
	var output = []
	print(cmd)
	var error_code = OS.execute("wsl.exe", ["bash", "-c", "cd " + pwd + "&& " +cmd], output, true)
	return String(output[-1])
	
func _on_line_edit_text_submitted(cmd: String):
	var input = $input
	input_list.append(cmd)
	print(input_list)
	var response =""
	if cmd == input.text:
		response = process_command(cmd)
	input.text = ""
	var output = $RichTextLabel
	output.text += response


func process_cd(command):
	var path = execute(command + "&& echo break && pwd ").split("break")
	print(path)
	if path.size() > 1:
		pwd = path[1].substr(path[1].find("user") ,-1) if "user" in path[1] else pwd
		pwd = pwd.strip_edges()
		print(path, pwd)
	return path[0]
	
func process_pwd(_cmd):
	return "/" + pwd
	
func process_clear(_cmd):
	var output = $RichTextLabel
	output.text = ""
	return ""
	
func process_manlevel(cmd):
	if cmd == "man level":
		emit_signal("man_level")
		return ""
	else:
		return execute(cmd) + "\n"

func get_input_list() -> Array:
	return input_list

func _input(event):
	if event.is_action_pressed("ui_up"):
		print("Up arrow is pressed")
		if curr == -1:
			curr = len(input_list) -1
		else:
			curr -= 1
			if curr < 0:
				curr = 0
		print("prvs cmd: ", input_list[curr])
		update_temp_ip()
	elif event.is_action_pressed("ui_down"):
		print("Down arrow is pressed")
		if curr == -1:
			curr = len(input_list) -1
		else:
			curr += 1
			if curr > len(input_list) -1:
				curr = len(input_list) -1
		print("prvs cmd: ", input_list[curr])
		update_temp_ip()
	elif event.is_action_pressed("ui_accept") and input_list != []:
		print("Enter key is pressed")
		curr = -1
		print("prvs cmd: ", input_list[curr])
		
			 
func update_temp_ip():	
	var temp_inp = $input
	if temp_inp:
		temp_inp.text = input_list[curr]
		
