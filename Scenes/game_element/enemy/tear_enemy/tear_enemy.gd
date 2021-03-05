extends "res://Scenes/game_element/enemy/enemy.gd"

onready var waterBullet = get_node("/root/Globals").water_bullet

var shoot_timer = 0
var shoot_time_limit

func _ready():
	#target = flamePlayer.position
	pass

func _physics_process(delta):
	if(!is_paused):
		shoot_timer += delta
		if(shoot_timer > shoot_time_limit):
			shoot(waterBullet)
			shoot_timer = 0
	print(shoot_time_limit)

func shoot(bullet):
	soundPlayer.get_node("TearEnemyShoot_Sound").play()
	var shoot_dir = (target.position - position).normalized()
	
	is_shooting = true
	if(shoot_dir.x >= 0): $AnimatedSprite.play("Shoot-Right")
	if(shoot_dir.x < 0): $AnimatedSprite.play("Shoot-Left")
	
	var newBullet = bullet.instance()
	newBullet.init(position, shoot_dir, 30, type)
	get_node("../Bullets").add_child(newBullet)

func _on_TearEnemy_area_entered(area):
	if area.type == "Bullet" and area.element == "Fire":
		reduce_hp()
		area.destroy();

func _on_AnimatedSprite_animation_finished():
	if(is_shooting): is_shooting = false
