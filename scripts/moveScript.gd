extends CharacterBody3D
const SPEED = 25.0
const BOOST = 580.0
const JUMP_VELOCITY = 10.0
var doubleJumped = false
var sliding = false
var can_slide = true	
var slide_speed = SPEED + 10
var cam
var direction
var input_dir

#start-up function
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam = $CameraContainer/Camera3D

#camera rotation
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.006)
		cam.rotate_x(-event.relative.y * 0.006)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#all physics func
func _physics_process(delta: float) -> void:
#gravity innit
	if not is_on_floor():
		velocity += get_gravity() * delta

#jump action
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		doubleJumped = false
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and not doubleJumped:
		doubleJumped = true
		velocity.y = JUMP_VELOCITY

#slide
	if Input.is_action_pressed("slide") and Vector3(velocity.x, 0, velocity.z).length() > 2 and can_slide and is_on_floor():
		sliding = true
		cam.transform.origin = Vector3(0, -0.3, 0)
		$CollisionShape3D.shape = load("res://scenes/PlayerCollisionSlide.tres")
		velocity.x = direction.x * slide_speed
		velocity.z = direction.z * slide_speed
		slide_speed = move_toward(slide_speed, 0, 0.25)
	elif not Input.is_action_pressed("slide"):
		sliding = false
		can_slide = true
		slide_speed = SPEED + 10
	elif Vector3(velocity.x, 0, velocity.z).length() <= 2:
		can_slide = false
		sliding = false
		
	if not sliding:
		cam.transform.origin = Vector3(0, 0, 0)
		$CollisionShape3D.shape = load("res://scenes/PlayerCollision.tres")
		#input for directional travel
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#base speed levels
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/6)
			velocity.z = move_toward(velocity.z, 0, SPEED/6)

#dashcooldown ended
		if $dashCooldown.time_left == 0:
			#print_debug("dash ready")
			pass

#enable dash
		if direction and Input.is_action_just_pressed("dash") and $dashCooldown.time_left == 0:
			$dashTimer.start()
			$dashCooldown.start()
			#print_debug("dash started")

#during dash, increase speed
		if $dashTimer.time_left > 0:
			velocity.x = direction.x * BOOST
			velocity.z = direction.z * BOOST

#dash stop checker and cooldown reset
		if $dashTimer.time_left == 0:
			#print_debug("dash stopped")
			#print_debug("cooldown reset")
			pass
	move_and_slide()
