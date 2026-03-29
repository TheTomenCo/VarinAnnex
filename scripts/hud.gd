extends Control

func changeHp(HP):
	var fullRect = Rect2(0, 0, 1275, 97)
	var variableRect = Rect2(0, 0, 77 * (int((HP/100.0) * 1155) / 77), 97)
	var overchargeRect = Rect2(0, 0, 77 * (int(((HP - 100)/100.0) * 1155) / 77), 97)
	if HP == 100:
		$CanvasLayer/Health/HealthBar.region_rect = fullRect
	elif HP < 100:
		$CanvasLayer/Health/HealthBar.region_rect = variableRect
	if HP == 200:
		$CanvasLayer/Health/HealthBarOvercharge.region_rect = fullRect
		overcharge(true)
	elif HP > 100:
		$CanvasLayer/Health/HealthBarOvercharge.region_rect = overchargeRect
		overcharge(true)
	else: 
		overcharge(false)
		
func changeAmmo(Ammo, maxAmmo):
	$CanvasLayer/Ammo/Ammo.text = str(Ammo) + " / " + str(maxAmmo)
	
func changeTotalAmmo(TotalAmmo):
	$CanvasLayer/Ammo/TotalAmmo.text = str(TotalAmmo)
	
func changeDashCooldown(time, maxTime):
	$DashCooldown.start(maxTime)
	$DiscretionTimer.start()
	
func changeWeapon(Weapon):
	if Weapon == "pistol":
		pass
	elif Weapon == "shotgun":
		pass

func overcharge(activate):
	if activate:
		$CanvasLayer/Health/HealthBarOvercharge.visible = true
		$CanvasLayer/Health/HealthBarBackgroundOvercharge.visible = true
		$CanvasLayer/Health/WeaponSelectDetailsOvercharge.visible = true
		$CanvasLayer/Health/DashOvercharge.visible = true
	else:
		$CanvasLayer/Health/HealthBarOvercharge.visible = false
		$CanvasLayer/Health/HealthBarBackgroundOvercharge.visible = false	
		$CanvasLayer/Health/WeaponSelectDetailsOvercharge.visible = false	
		$CanvasLayer/Health/DashOvercharge.visible = false

func _on_discretion_timer_timeout() -> void:
	var length = Rect2(0, 0, abs((420 * ($DashCooldown.time_left/$DashCooldown.wait_time)) - 420), 50)
	$CanvasLayer/Health/Dash.region_rect = length
	$CanvasLayer/Health/DashOvercharge.region_rect = length

func _on_dash_cooldown_timeout() -> void:
	$CanvasLayer/Health/Dash.region_rect = Rect2(0, 0, 420, 50)
	$CanvasLayer/Health/DashOvercharge.region_rect = Rect2(0, 0, 420, 50)
	$DiscretionTimer.stop()
	
