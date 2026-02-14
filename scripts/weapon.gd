extends Node
var MaxAmmo = 10
var Ammo = MaxAmmo
var Damage = 10
var Cooldown = 0.5
var ReloadTime = 0.5

func _ready() -> void:
	$CooldownTimer.wait_time = Cooldown
	$ReloadTimer.wait_time = ReloadTime

func _process(delta):
	if Input.is_action_just_pressed("shoot") and $CooldownTimer.is_stopped() and $ReloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			if $RayCast3D.is_colliding():
				print("Hit ", $RayCast3D.get_collider().get_parent().name, " at ", $RayCast3D.get_collision_point(), " and dealt ", Damage, " damage")
	if Input.is_action_just_pressed("reload"):
		print("Reloading")
		$ReloadTimer.start()
		Ammo = MaxAmmo
