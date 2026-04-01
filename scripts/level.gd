extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		Save()
	if Input.is_action_just_pressed("load"):
		Load()

func Save():
	var save_data = {}
	for child in get_children():
		if child.is_in_group("Save"):
			save_data.merge({child.name : child.save()})
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))

func Load():
	get_tree().paused = true
	if FileAccess.file_exists("res://save.tscn"):
		if FileAccess.file_exists("user://save.json"):
			var file = FileAccess.open("user://save.json", FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			for entry in data:
				var object = find_child(entry)
				if is_instance_valid(object): 
					if object.has_method("load"):
						object.load(data[object.name])
				else:
					object = load(data[entry]["scene"]).instantiate()
					add_child(object)
					if object.has_method("load"):
						object.load(data[entry])
			for child in get_children():
				if child.is_in_group("Temporary"):
					child.queue_free()
	get_tree().paused = false
