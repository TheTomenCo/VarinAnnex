extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 2.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

#if not on player, move toward player

#if collision with player, stop moving
	move_and_slide()
