extends CharacterBody3D

@onready var navigation = $NavigationAgent3D
@export var speed = 5.0
@export var maxHP = 100
@export var visionRange = 30
@export var attackRange = 1
@export var damage = 10
var HP = maxHP
@onready var player

func _ready() -> void:
	if get_tree().root.get_node("Level/player"):
		player = get_tree().root.get_node("Level/player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	look_at(Vector3(player.position.x, position.y, player.position.z))
	if position.distance_to(player.position) < visionRange:
		navigation.target_position = player.position
	var destination = navigation.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	if position.distance_to(player.position) < attackRange:
		dealDamage(damage)
	move_and_slide()
	
func dealDamage(damage):
	player.modifyHP(-damage)

func modifyHP(Amount):
	print(HP + Amount)
	if HP + Amount > 0:
		HP += Amount
	else:
		die()

func die():
	queue_free()
