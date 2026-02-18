@tool
extends Node3D
enum Type {ammo, health}
@export var type: Type = Type.ammo

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		change_color()

func _ready() -> void:
	if not Engine.is_editor_hint():
		change_color()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not Engine.is_editor_hint():
		if body.is_class("CharacterBody3D"):
			if type == Type.health:
				body.fullHeal()
			elif type == Type.ammo:
				body.get_node("CameraContainer/Weapon").modifyAmmo(100)
			self.queue_free()

func change_color():
	if type == Type.ammo:
		var material = StandardMaterial3D.new()
		material = material.duplicate()
		material.albedo_color = Color(0, 0, 1, 1)
		$MeshInstance3D.material_override = material
	else:
		var material = StandardMaterial3D.new()
		material = material.duplicate()
		material.albedo_color = Color(1, 0, 0, 1)
		$MeshInstance3D.material_override = material
