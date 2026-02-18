extends Control

func changeHp(HP):
	$CanvasLayer/HP.text = str(HP)
	
func changeAmmo(Ammo, maxAmmo):
	$CanvasLayer/Ammo.text = str(Ammo) + " / " + str(maxAmmo)
	
func  changeTotalAmmo(TotalAmmo):
	$CanvasLayer/TotalAmmo.text = str(TotalAmmo)
