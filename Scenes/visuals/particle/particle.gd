extends Node2D

var is_paused = false

func _on_AnimatedSprite_animation_finished():
	get_parent().remove_child(self)
	queue_free()
