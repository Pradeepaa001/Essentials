extends Node

var save_path = "user://savegame.save"

func reset_progress():
	var save_data = load_progress()
	save_data["levels_completed"] = {}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()

func save_progress(level_completed: int):
	var save_data = load_progress()
	if level_completed not in save_data["levels_completed"]:
		save_data["levels_completed"].append(level_completed)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()

func load_progress() -> Dictionary:
	var save_data = {"levels_completed": []}
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		save_data = file.get_var()
		file.close()
	print(save_data)
	return save_data
