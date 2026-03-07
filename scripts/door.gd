extends Node3D

var opened = false
var moving = false
var anim_player: AnimationPlayer
var close_delay: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player = $AnimationPlayer
	#anim_player.active = true
	close_delay = $CloseDelay
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	close()

func open():
	if opened == false and moving == false:
		print("opening")
		moving = true
		anim_player.play("open")
		
func close():
	#print(close_delay.is_stopped())
	if opened == true and moving == false and close_delay.is_stopped():
		print("closing")
		moving = true
		anim_player.play("close")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		print("finished opening")
		close_delay.start()
		opened = true
		moving = false
	elif anim_name == "close":
		print("finished closing")
		#close_delay.start()
		opened = false
		moving = false
