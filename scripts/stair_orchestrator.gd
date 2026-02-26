extends Node3D
@export_range(0.1, 2) var steepness = 1.0
@export var steps = 3

func _ready() -> void:
	for i in range(steps):
		var step = $StaticBody3D/MeshInstance3D.duplicate()
		$StaticBody3D.add_child(step)
		step.scale += Vector3(0, i * steepness, 0)
		step.position += Vector3(0, (i * steepness)/2, i)
		$StaticBody3D/CollisionShape3D.scale += Vector3(0, i * steepness * 2, 0)
		$StaticBody3D/CollisionShape3D.position += Vector3(0, 0.5, 0.5)
