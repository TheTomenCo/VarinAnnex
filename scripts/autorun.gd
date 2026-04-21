extends Node

var last_player_rot: Vector3
var last_camera_rot: Vector3

func get_player(parent = get_tree().root) -> CharacterBody3D:
	for node in parent.get_children():
		#print(node, " ", typeof(node), " ", node.get_class())
		if node.name == "player":
			#print("Found!")
			return node#.get_node("AbsolutePlayer")

		var result = get_player(node)
		if result != null:
			return result

	return null

func get_camera() -> Node3D:
	var player = get_player()
	if player:
		return player.get_node("CameraContainer")
	return null

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pass
			#get_tree().quit()
	if Input.is_action_just_pressed("unlock mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			print("unlocked")
			var player = get_player()
			if player:
				last_player_rot = player.rotation
				last_camera_rot = get_camera().rotation
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			print("locked")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var camera: Camera3D = $player/AbsolutePlayer/CameraContainer/Camera3D
	#print(camera.global_position, camera.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		var player = get_player()
		if player:
			player.rotation = last_player_rot
			get_camera().rotation = last_camera_rot
			#print(camera.rotation)
