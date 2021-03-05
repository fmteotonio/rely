extends "res://Scenes/game_element/enemy/enemy.gd"

onready var waterBullet = get_node("/root/Globals").water_bullet
onready var fireBullet = get_node("/root/Globals").fire_bullet

var shoot_timer = 3
var shoot_time_limit = 4

var nextBullet

func _ready():
	enemyId = "TideEnemy"
	element = "Water"
	hp = 150
	max_hp = 150
	speed = 3
	max_speed = 3
	acceleration = 0.1
	score = 1000
	nextBullet = fireBullet

func _physics_process(delta):
	if(!is_paused):
		shoot_timer += delta
		if(shoot_timer > shoot_time_limit):
			shoot(nextBullet)
			if(nextBullet == fireBullet): nextBullet = waterBullet
			else: nextBullet = fireBullet
			shoot_timer = 0

func _on_TideEnemy_area_entered(area):
	if area.type == "Bullet" and area.element == "Fire" and area.shooter_type != type:
		reduce_hp()
		area.destroy();
		
func destroy():
	.destroy()
	

func shoot(bullet):
	
	soundPlayer.get_node("SpreaderEnemyShoot_Sound").play()
	var flame_dir = (flamePlayer.position - position).normalized()
	var _flower_dir = (flowerPlayer.position - position).normalized()
	
	is_shooting = true
	if(flame_dir.x >= 0): $AnimatedSprite.play("Shoot-Right")
	if(flame_dir.x < 0): $AnimatedSprite.play("Shoot-Left")
	
	var newBullet = bullet.instance()
	if(bullet == waterBullet):
		for i in range(-15,16,1):
			newBullet = bullet.instance()
			newBullet.init(position, flame_dir.rotated(PI/31*i) , 50, type)
			get_node("../Bullets").add_child(newBullet)
	if(bullet == fireBullet):
		for i in range(-15,-1,1):
			newBullet = bullet.instance()
			newBullet.init(position, flame_dir.rotated(PI/31*i) , 50, type)
			get_node("../Bullets").add_child(newBullet)
		for i in range(2,16,1):
			newBullet = bullet.instance()
			newBullet.init(position, flame_dir.rotated(PI/31*i) , 50, type)
			get_node("../Bullets").add_child(newBullet)


func _on_AnimatedSprite_animation_finished():
	if(is_shooting): is_shooting = false
