extends Node3D
@export var weapons: Array = [load("res://scenes/weapons/pistol.tscn")]
var selected = 0

func _ready() -> void:
	for weapon in weapons:
		if weapon:
			var instance = weapon.instantiate()
			add_child(instance)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		get_child(selected).shoot()
	if Input.is_action_just_pressed("reload"):
		get_child(selected).reload()
	for i in range(1, get_child_count() + 1):
		if Input.is_action_just_pressed("slot%d" % i) and get_child(i - 1):
			get_child(selected).get_child(-1).stop()
			selected = i - 1
			get_child(selected).modifyAmmo(0)

func addWeapon(Weapon):
	for child in get_children():
		child.queue_free()
	if Weapon not in weapons and Weapon != 0:
		weapons.append(load(Weapon))
	for weapon in weapons:
		add_child(weapon)
