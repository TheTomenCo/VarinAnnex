extends Node3D
var MaxAmmo = 10
var Ammo = MaxAmmo
var TotalAmmo = 100 # Extra magazines
var Damage = 10
var Cooldown = 0.5
var ReloadTime = 0.5
var maxRange = 32
var spread = 0
var bulletHole = preload("res://scenes/weapons/bullet_hole.tscn")
var reloadTimer
var HUD
var scene = "res://scenes/weapons/pistol.tscn"
var automatic = false

func _ready() -> void:
	HUD = get_parent().get_parent().get_parent().get_node("Hud")
	reloadTimer = createReloadTimer()
	$CooldownTimer.wait_time = Cooldown
	reloadTimer.wait_time = ReloadTime
	$RayCast3D.scale.y = maxRange
	modifyAmmo(0)

func shoot():
	if $CooldownTimer.is_stopped() and reloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			if $RayCast3D.is_colliding():
				createBulletHole($RayCast3D)
				dealDamage($RayCast3D, Damage)
	if HUD:
		HUD.changeAmmo(Ammo, MaxAmmo)
	
func reload():
	if reloadTimer.is_stopped() and TotalAmmo > 0:
		print("Reloading")
		reloadTimer.start()
		if HUD:
			HUD.changeAmmo(0, MaxAmmo)
	
func modifyAmmo(AmmoAmount):
	if TotalAmmo + AmmoAmount >= 0:
		TotalAmmo += AmmoAmount
	else:
		TotalAmmo = 0
	if HUD:
		HUD.changeTotalAmmo(TotalAmmo)
		HUD.changeAmmo(Ammo, MaxAmmo)

func createBulletHole(raycast):
	if not raycast.get_collider().is_class("CharacterBody3D"):
		var hole = bulletHole.instantiate()
		var scalingFactor = randf_range(0.8, 1.1)
		hole.get_child(0).scale = hole.get_child(0).scale * scalingFactor
		hole.position = raycast.get_collision_point() + raycast.get_collision_normal() / 100
		hole.basis = hole.basis.looking_at(raycast.get_collision_normal(), Vector3.UP)
		hole.rotation.z += randf_range(-PI, PI)
		get_tree().root.get_node("Level").add_child(hole)

func dealDamage(raycast, damage):
	var body = raycast.get_collider()
	var collision = body.shape_owner_get_owner(body.shape_find_owner(raycast.get_collider_shape()))
	if body.is_class("CharacterBody3D") and body.has_method("modifyHP"):
		if collision.name == "HeadHit":
			body.modifyHP(-damage * 2)
		elif collision.name == "BodyHit":
			body.modifyHP(-damage)

func _on_timer_timeout() -> void:
	var tempAmmo = TotalAmmo
	modifyAmmo(Ammo - MaxAmmo)
	Ammo = clamp(0, Ammo + tempAmmo, MaxAmmo)
	if HUD:
		HUD.changeAmmo(Ammo, MaxAmmo)

func createReloadTimer():
	reloadTimer = Timer.new()
	reloadTimer.one_shot = true
	reloadTimer.timeout.connect(_on_timer_timeout)
	add_child(reloadTimer)
	return reloadTimer
