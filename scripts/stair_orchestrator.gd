@tool
extends Node3D
@export_range(0, 1) var steepness = 0.25:
	set(value):
		steepness = value
		if Engine.is_editor_hint():
			createStairs()
@export var width = 5:
	set(value):
		width = value
		if Engine.is_editor_hint():
			createStairs()
@export var steps = 3:
	set(value):
		steps = value
		if Engine.is_editor_hint():
			createStairs()
			
func _ready() -> void:
	createStairs()

func createStairs():
	if is_instance_valid($StaticBody3D):
		for child in $StaticBody3D.get_children():
			if child != $StaticBody3D/CollisionShape3D and child != $StaticBody3D/MeshInstance3D:
				child.queue_free()
		$StaticBody3D/MeshInstance3D.scale = Vector3(width, 1, 1)
		$StaticBody3D/CollisionShape3D.scale = Vector3(width, 1, 1)
		$StaticBody3D/CollisionShape3D.position = Vector3(0, 0.15, -0.075)
		var topStepCollision = $StaticBody3D/CollisionShape3D.duplicate()
		topStepCollision.position = Vector3(0, (steps-1)*steepness, steps-1)
		topStepCollision.rotation = Vector3(0, 0, 0)
		$StaticBody3D/CollisionShape3D.rotation = Vector3(atan2(steps, steps*steepness), 0, 0)
		$StaticBody3D.add_child(topStepCollision)
		for i in range(steps):
			var step = $StaticBody3D/MeshInstance3D.duplicate()
			var stepCollision = topStepCollision.duplicate()
			$StaticBody3D.add_child(step)
			step.scale += Vector3(0, i * steepness, 0)
			step.position += Vector3(0, (i * steepness)/2, i)
			stepCollision.scale = step.scale
			stepCollision.position = step.position
			$StaticBody3D.add_child(stepCollision)
		$StaticBody3D/CollisionShape3D.position = Vector3(0, (steps+1)*steepness/2.0, steps/2.0)
		$StaticBody3D/CollisionShape3D.translate_object_local(Vector3(0, -1.75, 0))
		$StaticBody3D/CollisionShape3D.scale.y = Vector2(steps, steps*steepness).length()
