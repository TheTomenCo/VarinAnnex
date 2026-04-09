extends CharacterBody3D
@export var speed = 7.0
const BOOST = 250.0
const JUMP_VELOCITY = 3.50
var MaxHP = 100
var HP = MaxHP
var doubleJumped = false
var sliding = false
var can_slide = true
var slide_speed = speed + 10
var cam
var direction
var input_dir
var dashCounter = 0

#start-up function
func _ready():
	add_to_group("Save")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam = $CameraContainer
	modifyHP(0)

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
		if position.y <= -50:
			position = Vector3(-1, 1.1, 0)

#jump action
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		doubleJumped = false
		velocity.y = JUMP_VELOCITY
	#double jump
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and not doubleJumped:
		doubleJumped = true
		velocity.y = JUMP_VELOCITY
		$doubleJumpStream.play()

#slide
	if Input.is_action_pressed("slide") and Vector3(velocity.x, 0, velocity.z).length() > 2 and can_slide and is_on_floor():
		$slideStream.play()
		sliding = true
		cam.transform.origin = Vector3(0, -0.3, 0)
		$CollisionShape3D.shape = load("res://assets/materials/player/PlayerCollisionSlide.tres")
		velocity.x = direction.x * slide_speed
		velocity.z = direction.z * slide_speed
		slide_speed = move_toward(slide_speed, 0, 0.25)
	elif not Input.is_action_pressed("slide"):
		sliding = false
		can_slide = true
		slide_speed = speed + 10
	elif Vector3(velocity.x, 0, velocity.z).length() <= 2:
		can_slide = false
		sliding = false
		
	if not sliding:
		cam.transform.origin = Vector3(0, 0, 0)
		$CollisionShape3D.shape = load("res://assets/materials/player/PlayerCollision.tres")
		#input for directional travel
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#base speed levels
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed / 6)
			velocity.z = move_toward(velocity.z, 0, speed / 6)

#dashcooldown ended
		if $dashCooldown.time_left == 0:
			dashCounter = 0
			pass

#enable dash
		if direction and Input.is_action_just_pressed("dash") and ((dashCounter == 1 and HP > 100) or $dashCooldown.time_left == 0):
			dashCounter += 1
			$dashTimer.start()
			$dashCooldown.start()
			$dashStream.play()
			$Hud.changeDashCooldown($dashCooldown.wait_time)
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

func modifyHP(HPAmount):
	if HP + HPAmount >= 0 and $invincibilityTimer.is_stopped():
		HP += HPAmount
		if HPAmount < 0 and HPAmount <= 100:
			$invincibilityTimer.start()
		if $Hud:
			$Hud.changeHp(HP)

func fullHeal():
	HP = MaxHP
	if $Hud:
		$Hud.changeHp(HP)
		
func save():
	var weapons = $CameraContainer/weaponHandler
	return {"position" : {"x" : position.x, "y" : position.y, "z" : position.z},
	"hp" : HP,
	"weapons" : weapons.save()}
	
func load(data):
	var weapons = $CameraContainer/weaponHandler
	position = Vector3(data["position"]["x"], data["position"]["y"], data["position"]["z"])
	HP = int(data["hp"])
<<<<<<< Updated upstream
	weapons.load(data["weapons"])
=======
	weapons.weapons = data["weapons"]
	weapons.selected = data["selected_weapon"]
	weapons.get_child(weapons.selected).Ammo = int(data["ammo"])
	weapons.get_child(weapons.selected).TotalAmmo = int(data["total_ammo"])
>>>>>>> Stashed changes
	if $Hud:
		$Hud.changeHp(HP)
		$Hud.changeAmmo(weapons.get_child(weapons.selected).Ammo, weapons.get_child(weapons.selected).MaxAmmo)
		$Hud.changeTotalAmmo(weapons.get_child(weapons.selected).TotalAmmo)

#change to death scene
func youDied():
	get_tree().change_scene_to_file("res://scenes/menus/death_screen.tscn")

#check if player died
func deadCheck():
	if HP == 0:
		youDied()
