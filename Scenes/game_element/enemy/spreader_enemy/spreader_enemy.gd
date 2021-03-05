extends "res://Scenes/game_element/enemy/enemy.gd"

onready var waterBullet = get_node("/root/Globals").water_bullet

var shoot_timer = 0
var shoot_time_limit = 3
var shot_speed = 30

func _ready():
	enemyId = "SpreaderEnemy"
	element = "Water"
	hp = 42
	max_hp = 42
	speed = 2
	max_speed = 2
	acceleration = 0.1
	score = 200

func _physics_process(delta):
	if(!is_paused):
		shoot_timer += delta
		if(shoot_timer > shoot_time_limit):
			shoot(waterBullet)
			shoot_timer = 0

func _on_SpreaderEnemy_area_entered(area):
	if area.type == "Bullet" and area.element == "Fire":
		reduce_hp()
		area.destroy();
		
func destroy():
	.destroy()
	

func shoot(bullet):
	
	soundPlayer.get_node("SpreaderEnemyShoot_Sound").play()
	var shoot_dir = (target.position - position).normalized()
	
	is_shooting = true
	if(shoot_dir.x >= 0): $AnimatedSprite.play("Shoot-Right")
	if(shoot_dir.x < 0): $AnimatedSprite.play("Shoot-Left")
	
	var newBullet
	for i in range(-15,16,1):
		newBullet = bullet.instance()
		newBullet.init(position, shoot_dir.rotated(PI/31*i) , shot_speed, type)
		newBullet.limit_min = bullet_min
		newBullet.limit_max = bullet_max
		get_node("../Bullets").add_child(newBullet)


func _on_AnimatedSprite_animation_finished():
	if(is_shooting): is_shooting = false
