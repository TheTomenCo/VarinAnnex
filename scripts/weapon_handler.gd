extends Node3D
@export var weapons: Array = [load("res://scenes/weapons/pistol.tscn")]
var selected = 0

func _ready() -> void:
	for weapon in weapons:
		if weapon:
			var instance = weapon.instantiate()
			add_child(instance)

func _process(delta: float) -> void:
	if (Input.is_action_pressed("shoot") and get_child(selected).automatic):
		get_child(selected).shoot()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		get_child(selected).shoot()
		if get_child(selected).automatic == true:
			get_child(selected).shootingTimer.start()
	if Input.is_action_just_pressed("reload"):
		get_child(selected).reload()
	for i in range(1, get_child_count() + 1):
		if Input.is_action_just_pressed("slot%d" % i) and get_child(i - 1):
			get_child(selected).get_child(-1).stop()
			selected = i - 1
			get_child(selected).modifyAmmo(0)

func addWeapon(Weapon):
	if Weapon not in weapons:
		var object = Weapon.instantiate()
		weapons.append(Weapon)
		add_child(object)
		selected = len(weapons) - 1
		
func save():
	var children = {}
	for child in get_children():
		children.merge({child.name : {"Ammo" : child.Ammo, "TotalAmmo" : child.TotalAmmo, "scene" : child.scene}})
	var data = {"children" : children, "selected" : selected}
	return data
	
func load(data):
	for entry in data["children"]:
		var object = get_node(entry)
		if is_instance_valid(object):
			object.Ammo = int(data["children"][entry]["Ammo"])
			object.TotalAmmo = int(data["children"][entry]["TotalAmmo"])
		else:
			addWeapon(load(data["children"][entry]["scene"]))
			var weapon = get_child(-1)
			weapon.Ammo = int(data["children"][entry]["Ammo"])
			weapon.TotalAmmo = int(data["children"][entry]["TotalAmmo"])
	selected = data["selected"]
