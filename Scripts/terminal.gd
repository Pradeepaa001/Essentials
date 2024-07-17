extends Node2D
class_name Terminal
#signal command_executed(String command, String response)

var pwd = "user"

func _ready():
	pass

func processCommand(cmd: String) -> String:
	var response: String = "$"+ cmd + "\n"
	var grey_list_commands = ["cd", "pwd", "mkdir", "ls", "touch"]
	var grey_list_processing = [process_cd, process_pwd, process_mkdir, process_ls, process_touch]
	var command = cmd.split(" ")

	for idx in grey_list_commands.size():
		if grey_list_commands[idx] == command[0]:
			#emit_signal("command_executed", command[0], response)
			return response + grey_list_processing[idx].call(command) + "\n"
	#emit_signal("command_executed", command[0], response)		
	return response + execute(command)
	
func execute(cmd):
	var output = []
	var error_code = OS.execute("wsl.exe",cmd, output, true)
	print(output)
	return String(output[-1])
	
func _on_line_edit_text_submitted(cmd: String):
	var response = processCommand(cmd)
	$input.text = ""
	var output = $output
	output.text += response
	
	
func process_cd(cmd):
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
	else:
		var path = "res://" + pwd
		var dir = DirAccess.open(path)
		if dir.dir_exists(cmd[-1]):
			dir.change_dir(cmd[-1])
			pwd += "/" + cmd[-1]
			return ""
		return "-bash: cd: " + cmd[-1] + ": No such file or directory"

func process_pwd(cmd):
	return "/" + pwd

func process_mkdir(cmd):
	if cmd.size() == 1:
		execute(cmd)
	elif "-" in cmd[1]:
		return "Not supported"
	else:
		var path = "res://" + pwd
		var dir = DirAccess.open(path)
		var response =""
		for command in cmd.slice(1,cmd.size()):
			if dir.dir_exists(command):
				response += "mkdir: cannot create directory ‘" + command + "’: File exists\n"
			else:
				dir.make_dir(command)
		return response
		
func process_ls(cmd):
	cmd.append(pwd)
	return execute(cmd)

func process_touch(cmd):
	if "-" in cmd[1]:
		return "Command not supported"
	var path = "res://" + pwd
	print(cmd)
	for command in cmd.slice(1,cmd.size()):
		var file = FileAccess.open(path + "/" + command,FileAccess.WRITE)
	return ""
	
	
