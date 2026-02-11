extends CharacterBody3D
const SPEED = 25.0
const BOOST = 580.0
const JUMP_VELOCITY = 40.0

#start-up function
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#camera rotation
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.006)
		$Camera3D.rotate_x(-event.relative.y * 0.006)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#all physics func
func _physics_process(delta: float) -> void:
#gravity innit
	if not is_on_floor():
		velocity += get_gravity() * delta

#jump action
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#input for directional travel
	var input_dir := Input.get_vector("backward", "forward", "left", "right")
	#need to add a dash, i.e. current direction * BOOST
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#base speed levels
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

#dashcooldown ended
	if $dashCooldown.time_left == 0:
		print_debug("dash ready")

#enable dash
	if direction and Input.is_action_just_pressed("dash") and $dashCooldown.time_left == 0:
		$dashTimer.start()
		$dashCooldown.start()
		print_debug("dash started")

#during dash, increase speed
	if $dashTimer.time_left > 0:
		velocity.x = direction.x * BOOST
		velocity.z = direction.z * BOOST

#dash stop checker and cooldown reset
	if $dashTimer.time_left == 0:
		print_debug("dash stopped")
		print_debug("cooldown reset")
	move_and_slide()
