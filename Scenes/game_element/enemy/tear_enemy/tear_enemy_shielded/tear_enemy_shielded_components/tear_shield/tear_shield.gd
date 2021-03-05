extends "res://Scenes/game_element/enemy/enemy.gd"

func _ready():
	flamePlayer = get_node("../../FlamePlayer")
	flowerPlayer = get_node(".../../FlowerPlayer")
	waveManager  = get_node("../../WaveManager")
	target = flamePlayer
	
	get_parent().get_node("CollisionPolygon2D").set_deferred("disabled", true)
	enemyId = "EnemyTearShield"
	element = "Fire"
	hp = 1
	max_hp = 1
	speed = 0
	max_speed = 0
	acceleration = 0.0
	score = 0
	
func _on_TearShield_area_entered(area):
	if area.type == "Bullet" and area.element == "Water" and area.is_parried:
		get_parent().get_node("CollisionPolygon2D").set_deferred("disabled", false)
		reduce_hp()
	if area.type == "Bullet" and area.element == "Fire":
		area.destroy()
