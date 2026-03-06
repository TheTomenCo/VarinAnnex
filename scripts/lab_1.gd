extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		Save()
	if Input.is_action_just_pressed("load"):
		Load()
	
func Save():
	var packedScene = PackedScene.new()
	packedScene.pack(self)
	ResourceSaver.save(packedScene, "res://save.tscn")

func Load():
	if FileAccess.file_exists("res://save.tscn"):
		get_tree().change_scene_to_file("res://save.tscn")
