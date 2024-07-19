extends Node

var pwd = "user"

func process_command(cmd: String) -> String:
	var response: String = "$" + cmd + "\n"
	var grey_list_commands = ["cd", "pwd"]
	var grey_list_processing = [self.process_cd, self.process_pwd]
	
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
	var response = process_command(cmd)
	var output = $output
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
