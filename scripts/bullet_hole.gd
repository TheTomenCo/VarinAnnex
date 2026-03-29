extends Node3D

func _ready() -> void:
	add_to_group("Temporary")

func _on_timer_timeout() -> void:
	queue_free()
