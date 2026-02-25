extends Node3D

func _ready() -> void:
	$Area3D/MeshInstance3D.queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		$AbsolutePlayer/damageStream.play()
		body.modifyHP(-20)
