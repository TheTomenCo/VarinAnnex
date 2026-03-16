extends "res://scripts/Weapon.gd"
var pellets = 30

func _ready() -> void:
	MaxAmmo = 2
	Ammo = MaxAmmo
	TotalAmmo = 15
	Damage = 2
	Cooldown = 0.5
	ReloadTime = 0.5
	$CooldownTimer.wait_time = Cooldown
	$ReloadTimer.wait_time = ReloadTime
	modifyAmmo(0)

func shoot():
	if $CooldownTimer.is_stopped() and $ReloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			for i in range(pellets - 1):
				var raycast = $RayCast3D.duplicate()
				add_child(raycast)
				raycast.rotate_y(randf_range(-PI/6, PI/6))
				raycast.rotate_x(randf_range(-PI/6, PI/6))
				raycast.force_raycast_update()
			var hits = 0
			var collider
			for child in get_children():
				if child is RayCast3D:
					if child.is_colliding():
						createBulletHole(child)
						hits += 1
						collider = child
					if child != $RayCast3D:
						pass
						remove_child(child)
			if collider:
				print(hits, " pellets hit ", collider.get_collider().get_parent().name, " at ", collider.get_collision_point(), " and dealt a total of ", Damage*hits, " damage")
				
	if get_tree().root.get_node("Lab1/Hud"):
		if get_tree().root.get_node("Lab1/Hud"):
			get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
