extends Node2D

#@onready var quit_button = $Button2


@onready var confirm_dialog = $ConfirmationDialog
@onready var help_button = $Toolbar/HelpButton
@onready var help_window = $WindowDialog
@onready var info_label = $WindowDialog/InfoLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	help_window.hide()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if help_window.visible and Input.is_action_pressed("ui_cancel"):
		help_window.hide()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")

func _on_button_2_pressed():
	confirm_dialog.popup_centered()

func _on_confirmation_dialog_canceled():
	pass

func _on_confirmation_dialog_confirmed():
	get_tree().quit()



func _on_help_button_pressed():
	help_window.popup_centered()

func _on_window_dialog_close_requested():
	help_window.hide()
