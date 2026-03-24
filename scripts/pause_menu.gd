extends Control

func resumeCheck():
	get_tree().paused = false


func pauseCheck():
	get_tree().paused = true


func pause():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		visible = true
		pauseCheck()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		visible = false
		resumeCheck()


func _on_resume_pressed() -> void:
	resumeCheck()


func _on_settings_pressed() -> void:
	#change_scene_to_file("res://Menus/whatever_shi")
	pass


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
