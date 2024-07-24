extends Control

var dialogues = []
var current_index = 0

signal dialogue_finished

func _ready():
	self.hide()
	set_process_input(false)

func start_dialogue(dialogue_lines):
	dialogues = dialogue_lines
	current_index = 0
	set_process_input(true)
	self.show()
	show_next_line()

func show_next_line():
	if current_index < dialogues.size():
		$RichTextLabel.text = dialogues[current_index]
		current_index += 1
	else:
		end_dialogue()

func end_dialogue():
	self.hide()
	set_process_input(false)
	emit_signal("dialogue_finished")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_next_line()


