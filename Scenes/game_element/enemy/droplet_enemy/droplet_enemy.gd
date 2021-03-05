extends "res://Scenes/game_element/enemy/enemy.gd"

var shoot_timer = 0
var shoot_time_limit = 1

func _ready():
	enemyId = "DropletEnemy"
	element = "Water"
	hp = 3
	max_hp = 3
	speed = 30
	max_speed = 30
	acceleration = 30
	score = 10

func _on_DropletEnemy_area_entered(area):
	if area.type == "Bullet" and area.element == "Fire":
		reduce_hp()
		area.destroy();
