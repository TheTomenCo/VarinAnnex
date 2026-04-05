extends CharacterBody3D

@onready var navigation = $NavigationAgent3D
@export var speed = 5.0
@export var jump_velocity = 2.5
@export var maxHP = 100
var HP = maxHP
var damage = 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if get_tree().root.get_node("Level/player"):
		var player = get_tree().root.get_node("Level/player")
		if position.distance_to(player.position) < 15:
			look_at(Vector3(player.position.x, position.y, player.position.z))
			navigation.target_position = player.position
	var destination = navigation.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	move_and_slide()

func modifyHP(Amount):
	print(HP + Amount)
	if HP + Amount > 0:
		HP += Amount
	else:
		die()

func die():
	queue_free()
