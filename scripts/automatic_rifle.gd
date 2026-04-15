extends "res://scripts/weapon.gd"
var shootingTimer
var coefficient = 0

func _ready() -> void:
	scene = "res://scenes/weapons/automaticRifle.tscn"
	HUD = get_parent().get_parent().get_parent().get_node("Hud")
	shootingTimer = $CooldownTimer.duplicate()
	shootingTimer.wait_time = 5
	add_child(shootingTimer)
	automatic = true
	MaxAmmo = 30
	Ammo = MaxAmmo
	TotalAmmo = 120
	Damage = 5
	Cooldown = 0.1
	ReloadTime = 1.5
	maxRange = 50
	spread = PI/36
	reloadTimer = createReloadTimer()
	reloadTimer.wait_time = ReloadTime
	$CooldownTimer.wait_time = Cooldown
	$RayCast3D.scale.y = maxRange
	modifyAmmo(0)
	
func shoot():
	if $CooldownTimer.is_stopped() and reloadTimer.is_stopped():
		if Ammo > 0:
			$RayCast3D.rotation = Vector3(PI/2, 0, 0)
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			if shootingTimer.time_left == 0:
				coefficient = 0
			else: 
				coefficient = shootingTimer.wait_time - shootingTimer.time_left
			$RayCast3D.rotate_y(randf_range(-spread * coefficient, spread * coefficient))
			$RayCast3D.rotate_x(randf_range(-spread * coefficient, spread * coefficient))
			$RayCast3D.force_raycast_update()
			if $RayCast3D.is_colliding():
				createBulletHole($RayCast3D)
				dealDamage($RayCast3D, Damage)
			if HUD:
				HUD.changeAmmo(Ammo, MaxAmmo)
