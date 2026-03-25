extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		Save()
	if Input.is_action_just_pressed("load"):
		Load()

func Save():
	var save_data = {}
	save_data.merge({"player" : $player.get_child(0).save_data()})
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))

func Load():
	if FileAccess.file_exists("res://save.tscn"):
		if FileAccess.file_exists("user://save.json"):
			var file = FileAccess.open("user://save.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			$player.get_child(0).load_data(data["player"])
