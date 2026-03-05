extends Node3D

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< HEAD
	pass
=======
	print(1)

>>>>>>> 744f5c5eb5c2981ca7424e700bf79e6bb1c05cc1

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
