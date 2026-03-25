extends Node3D
@export var weapons: Array[PackedScene] = [load("res://scenes/weapons/pistol.tscn")]
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
	if Weapon not in weapons:
		weapons.append(Weapon)
	if weapons[-1]:
		var instance = weapons[-1].instantiate()
		add_child(instance)
		selected = len(weapons) - 1
