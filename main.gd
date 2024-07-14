extends Node2D

func _on_button_pressed():
	print('1')
	get_tree().change_scene_to_file("res://level_selector.tscn")
	print('2')

func _on_quit_pressed():
	get_tree().quit()
