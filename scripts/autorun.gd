extends Node


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
			
	if Input.is_action_just_pressed("unlock mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			print("unlocked")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			print("locked")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var camera: Camera3D = $player/AbsolutePlayer/CameraContainer/Camera3D
	#print(camera.global_position, camera.position)
	for child in get_children():
		print(child)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
