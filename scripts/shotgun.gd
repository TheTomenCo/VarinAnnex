extends "res://scripts/weapon.gd"
var pellets = 30

func _ready() -> void:
	scene = "res://scenes/weapons/shotgun.tscn"
	HUD = get_parent().get_parent().get_parent().get_node("Hud")
	MaxAmmo = 2
	Ammo = MaxAmmo
	TotalAmmo = 15
	Damage = 2
	Cooldown = 0.5
	ReloadTime = 0.5
	maxRange = 10
	spread = PI/6
	reloadTimer = createReloadTimer()
	reloadTimer.wait_time = ReloadTime
	$CooldownTimer.wait_time = Cooldown
	$RayCast3D.scale.y = maxRange
	modifyAmmo(0)

func shoot():
	if $CooldownTimer.is_stopped() and reloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			for i in range(pellets - 1):
				var raycast = $RayCast3D.duplicate()
				add_child(raycast)
				raycast.rotate_y(randf_range(-spread, spread))
				raycast.rotate_x(randf_range(-spread, spread))
				raycast.force_raycast_update()
			var hits = 0
			var collider
			for child in get_children():
				if child is RayCast3D:
					if child.is_colliding():
						createBulletHole(child)
						dealDamage(child, Damage)
						hits += 1
						collider = child
					if child != $RayCast3D:
						remove_child(child)
			if collider:
				print(hits, " pellets hit ", collider.get_collider().get_parent().name, " at ", collider.get_collision_point(), " and dealt a total of ", Damage*hits, " damage")
				
	if HUD:
		HUD.changeAmmo(Ammo, MaxAmmo)
