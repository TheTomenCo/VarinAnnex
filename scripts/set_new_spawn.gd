extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		print_debug("trigger hit")
		print_debug(body.global_position)
