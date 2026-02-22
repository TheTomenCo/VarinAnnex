extends Node
var MaxAmmo = 2
var Ammo = MaxAmmo
var TotalAmmo = 15 #Extra magazines
var Damage = 30
var Cooldown = 0.5
var ReloadTime = 0.5

func _ready() -> void:
	$CooldownTimer.wait_time = Cooldown
	$ReloadTimer.wait_time = ReloadTime

func shoot():
	if $CooldownTimer.is_stopped() and $ReloadTimer.is_stopped():
		if Ammo > 0:
			$CooldownTimer.start()
			Ammo -= 1
			print(Ammo, " bullets left")
			if $RayCast3D.is_colliding():
				print("Hit ", $RayCast3D.get_collider().get_parent().name, " at ", $RayCast3D.get_collision_point(), " and dealt ", Damage, " damage")
	if get_tree().root.get_node("Lab1/Hud"):
		if get_tree().root.get_node("Lab1/Hud"):
			get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
	
func reload():	
	if $ReloadTimer.is_stopped() and TotalAmmo > 0:
		print("Reloading")
		$ReloadTimer.start()
		Ammo = 0
		if get_tree().root.get_node("Lab1/Hud"):
			get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)

func _on_ReloadTimer_timeout():
	modifyAmmo(Ammo-MaxAmmo)
	Ammo = MaxAmmo
	if get_tree().root.get_node("Lab1/Hud"):
		get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
	
func modifyAmmo(AmmoAmount):
	TotalAmmo += AmmoAmount
	if get_tree().root.get_node("Lab1/Hud"):
		get_tree().root.get_node("Lab1/Hud").changeTotalAmmo(TotalAmmo)
		get_tree().root.get_node("Lab1/Hud").changeAmmo(Ammo, MaxAmmo)
