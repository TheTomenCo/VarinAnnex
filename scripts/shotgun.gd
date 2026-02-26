extends Node
var MaxAmmo = 2
var Ammo = MaxAmmo
var TotalAmmo = 15 #Extra magazines
var Damage = 2
var Cooldown = 0.5
var ReloadTime = 0.5
var pellets = 30

func _ready() -> void:
	$CooldownTimer.wait_time = Cooldown
	$ReloadTimer.wait_time = ReloadTime

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
						hits += 1
						collider = child
					if child != $RayCast3D:
						pass
						#remove_child(child)
			if collider:
				print(hits, " pellets hit ", collider.get_collider().get_parent().name, " at ", collider.get_collision_point(), " and dealt a total of ", Damage*hits, " damage")
				
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
