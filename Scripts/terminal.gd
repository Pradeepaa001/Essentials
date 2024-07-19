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
	var error_code = OS.execute("wsl.exe", ["sh", "-c", "cd " + pwd + "&& " +cmd], output, true)
	return String(output[-1])
	
func _on_line_edit_text_submitted(cmd: String):
	var input = $input
	var response = process_command(cmd)
	input.text = ""
	var output = $output
	output.text += response


func process_cd(command):
	var cmd = command.split(" ")
	print(cmd)
	if cmd.size() > 2:
		return "-bash: cd: too many arguments"
	elif cmd.size() == 1:
		pwd = "/user"
		return ""
	elif cmd[1] == "--help":
		return execute(cmd)
	elif "-" in cmd[1]:
		return "Not supported"
	elif command[-1] == "..":
		pwd = "/".join(pwd.split("/").slice(0, cmd.size() - 1))
	else:
		var path = "res://" + pwd
		var dir = DirAccess.open(path)
		if dir.dir_exists(cmd[-1]):
			dir.change_dir(cmd[-1])
			pwd += "/" + cmd[-1]
			return ""
		return "-bash: cd: " + cmd[-1] + ": No such file or directory"

func process_pwd(_cmd):
	return "/" + pwd
