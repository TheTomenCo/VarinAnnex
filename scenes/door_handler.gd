extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_door() -> Node3D:
	if $RayCast3D.is_colliding():
		var hit = $RayCast3D.get_collider().get_parent().get_parent()
		#var pos = $RayCast3D.get_collision_point()
		#print(hit.name, pos)
		if hit.name == "Door":
			return hit
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var door = get_door()
	if door:
		$Control.visible = true
		$Control/Label.text = 'Press "%s" to open' % InputMap.get_action_description("interact").split(" ")[0]
		if Input.is_action_pressed("interact"):
			#print("attempting to open")
			door.open()
	else:
		$Control.visible = false
		
	
		
