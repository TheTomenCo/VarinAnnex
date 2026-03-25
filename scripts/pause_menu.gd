extends CanvasLayer

func _ready() -> void:
	visible = false
	get_tree().paused = false


#open pause menu when esc is pressed and pause the game
#ISSUE 25/03/26: mouse is only re-locking when resume is pressed and not when pause is pressed again
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true


func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	get_tree().paused = false


func _on_settings_pressed() -> void:
	#change_scene_to_file("res://Menus/whatever_shi")
	#get_tree().paused = false
	pass


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
