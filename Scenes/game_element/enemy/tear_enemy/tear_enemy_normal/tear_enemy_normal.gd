extends "res://Scenes/game_element/enemy/tear_enemy/tear_enemy.gd"

func _ready():
	enemyId = "TearEnemyNormal"
	element = "Water"
	hp = 10
	max_hp = 10
	speed = 3
	max_speed = 3
	acceleration = 0.1
	score = 50
	shoot_time_limit = 1.5

func _on_TearEnemy_area_entered(area):
	._on_TearEnemy_area_entered(area)
	
func _on_AnimatedSprite_animation_finished():
	._on_AnimatedSprite_animation_finished()
