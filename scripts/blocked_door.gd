extends Node3D

@export var enemies : Array[CharacterBody3D] = []

var locked = false
var enemyCounter = len(enemies)

func _ready() -> void:
	$StaticBody3D/MeshInstance3D.visible = false

func _on_area_3d_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player":
		$StaticBody3D/MeshInstance3D.visible = true
		$StaticBody3D.set_collision_layer_value(1, true)

func _process(delta: float) -> void:
	if enemies.all(func(e): return e == enemies[0]) and $StaticBody3D/MeshInstance3D.visible == true:
		$StaticBody3D/MeshInstance3D.visible = false
		$StaticBody3D.set_collision_layer_value(1, false)
