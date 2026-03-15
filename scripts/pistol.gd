extends Node
var MaxAmmo = 10
var Ammo = MaxAmmo
var TotalAmmo = 100 #Extra magazines
var Damage = 10
var Cooldown = 0.5
var ReloadTime = 0.5
var bulletHole = preload("res://scenes/bullet_hole.tscn")

func _ready() -> void:
	$CooldownTimer.wait_time = Cooldown
	$ReloadTimer.wait_time = ReloadTime
	modifyAmmo(0)

func shoot():
	if $CooldownTimer.is_stopped() and $ReloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")		
			if $RayCast3D.is_colliding():
				print("Hit ", $RayCast3D.get_collider().get_parent().name, " at ", $RayCast3D.get_collision_point(), " and dealt ", Damage, " damage")
				var hole = bulletHole.instantiate()
				hole.position = $RayCast3D.get_collision_point() + $RayCast3D.get_collision_normal()/100
				hole.rotation = $RayCast3D.get_collision_normal()
				get_tree().root.get_node("Lab1").add_child(hole)
	if get_tree().root.get_node("Lab1/Hud"):
		if get_tree().root.get_node("Lab1/Hud"):
			get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
	
func reload():	
	if $ReloadTimer.is_stopped() and TotalAmmo > 0:
		print("Reloading")
		$ReloadTimer.start()
		if get_tree().root.get_node("Lab1/Hud"):
			get_tree().root.get_node("Lab1/Hud").changeAmmo(0, MaxAmmo)

func _on_ReloadTimer_timeout():
	var tempAmmo = TotalAmmo
	modifyAmmo(Ammo - MaxAmmo)
	Ammo = clamp(0, Ammo + tempAmmo, MaxAmmo)
	if get_tree().root.get_node("Lab1/Hud"):
		get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
	
func modifyAmmo(AmmoAmount):
	if TotalAmmo + AmmoAmount >= 0:
		TotalAmmo += AmmoAmount
	else:
		TotalAmmo = 0
	if get_tree().root.get_node("Lab1/Hud"):
		get_tree().root.get_node("Lab1/Hud").changeTotalAmmo(TotalAmmo)
		get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
