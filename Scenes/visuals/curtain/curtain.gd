extends Node2D

signal curtain_closed
signal curtain_opened

func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "Close"):
		emit_signal("curtain_closed")
	if($AnimatedSprite.animation == "Open"):
		emit_signal("curtain_opened")
