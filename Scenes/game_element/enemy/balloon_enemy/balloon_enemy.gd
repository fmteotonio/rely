extends "res://Scenes/game_element/enemy/enemy.gd"

onready var waterBullet = get_node("/root/Globals").water_bullet

var shoot_timer = 0
var shoot_time_limit = 4

func _ready():
	enemyId = "BalloonEnemy"
	element = "Water"
	hp = 10
	max_hp = 10
	speed = 5
	max_speed = 5
	acceleration = 0.1
	score = 50

func _on_BalloonEnemy_area_entered(area):
	if area.type == "Bullet" and area.element == "Fire":
		reduce_hp()
		area.destroy();
		
func destroy():
	shoot(waterBullet)
	.destroy()
	

func shoot(bullet):
	var shoot_dir = (target.position - position).normalized()
	var newBullet = bullet.instance()
	for i in range(-7,8,1):
		newBullet = bullet.instance()
		newBullet.init(position, shoot_dir.rotated(PI/15*i) , 30, type)
		get_node("../Bullets").add_child(newBullet)
