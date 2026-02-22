@tool
extends Node3D
enum Type {ammo, health, weapon}
@export var type: Type = Type.ammo:
	set(value):
		type = value
		notify_property_list_changed()
var Amount = 100
var WeaponScene

func _get_property_list():
	var properties = []
	if type == Type.weapon:
		properties.append({"name" : "WeaponScene",
						   "type" : TYPE_OBJECT, 
						   "usage" : PROPERTY_USAGE_DEFAULT})
	else:
		properties.append({"name" : "Amount",
						   "type" : TYPE_INT, 
						   "usage" : PROPERTY_USAGE_DEFAULT})
	return properties

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		change_color()

func _ready() -> void:
	if not Engine.is_editor_hint():
		change_color()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not Engine.is_editor_hint():
		if body.is_class("CharacterBody3D"):
			var weaponHandler = body.get_node("CameraContainer/weaponHandler")
			if type == Type.health:
				body.modifyHP(Amount)
			elif type == Type.ammo:
				weaponHandler.get_child(weaponHandler.selected).modifyAmmo(Amount)
			elif type == Type.weapon:
				if WeaponScene and WeaponScene not in weaponHandler.weapons: 
					weaponHandler.addWeapon(WeaponScene)
			self.queue_free()

func change_color():
	if type == Type.ammo:
		var material = StandardMaterial3D.new()
		material = material.duplicate()
		material.albedo_color = Color(0, 0, 1, 1)
		$MeshInstance3D.material_override = material
	elif type == Type.health:
		var material = StandardMaterial3D.new()
		material = material.duplicate()
		material.albedo_color = Color(1, 0, 0, 1)
		$MeshInstance3D.material_override = material
	else:
		var material = StandardMaterial3D.new()
		material = material.duplicate()
		material.albedo_color = Color(0, 1, 0, 1)
		$MeshInstance3D.material_override = material
