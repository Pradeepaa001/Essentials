extends Node

var pwd = "user"
var input_list = []
var curr = -1
signal man_level

func process_command(cmd: String) -> String:
	var response: String = "$" + cmd + "\n"
	
	var grey_list_commands = ["cd", "pwd", "clear", "man level", " .."]
	var grey_list_processing = [self.process_cd, self.process_pwd, self.process_clear, self.process_manlevel, self.process_back]
	

	var black_list_commands = [
	"ln", "dd", "mkfs", "mount", 
	"umount", "find", "scp", "sftp", "ncftp", "ftp", "wget", "curl", "shutdown", 
	"reboot", "halt", "poweroff", "init", "telinit", "service", "systemctl", "kill", 
	"pkill", "killall", "crontab", "batch", "ifconfig", "ip", "iptables", 
	"ip6tables", "route", "traceroute", "tracert", "netstat", "ping", "nmap", "telnet", 
	"ssh", "nc", "arp", "useradd", "userdel", "usermod", "groupadd", "groupdel", 
	"groupmod", "passwd", "su", "sudo", "csh", "zsh", "ksh", "env", 
	"set", "unset", "export", "source", "alias", "unalias", "exec", "make", "gcc", 
	"g++", "perl", "python", "ruby", "java", "javac", "pip", "npm", "apt-get", "yum", 
	"dnf", "brew", "git", "svn", "hg",
	"vi", "vim", "nano", "emacs", "ed", "df", "free", "ps", "top", "htop", "jobs", 
	"bg", "fg", "locate", "updatedb", "whereis", "which", "whatis", "id", 
	"last", "users", "uptime", "uname", "dmesg", "stat", "bc", "factor", "units", "expr", 
	"yes", "watch", "less", "comm", "diff", "patch",
	"xz", "unxz", "lzma", "unlzma", "zcat", "zless", "zdiff", "znew", "zcmp", "bc", 
	"dc", "test", "[", "read", "true", "false", "wait", "time", "umask", "ulimit", 
	"alias", "unalias", "fg", "bg", "jobs", "exec", "exit", "logout", "return", 
	"shift", "getopts", "dirs", "pushd", "popd", "declare", "typeset", "export", 
	"readonly", "local", "hash", "type", "command", "builtin", "caller", "eval", 
	"trap", "compgen", "complete", "compopt", "select", "bind", "disown", "coproc", 
	"sudoedit"
	]

	for idx in range(grey_list_commands.size()):
		for command in black_list_commands:
			print(command)
			if command in cmd:
				return response + "Command not supported" + "\n"
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

func process_back(command):
	return "No Access" if pwd == "user" else execute(command)
	
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
		
