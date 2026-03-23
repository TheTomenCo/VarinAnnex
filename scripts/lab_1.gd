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


#plan for SlaughterRoom
#for each instance of an enemy in the scene, add to a counter
#if the counter != 0, the the hitboxes on the garage doors stay
#if the counter == 0 then they remove the hitbox and plays an animation to open the door.
#opens all the doors but they can only complete one of the puzzles with the EQ they have at the time which blocks them just skipping to the boss
