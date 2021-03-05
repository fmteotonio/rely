extends "res://Scenes/game_element/player/player.gd"

onready var fireBullet = get_node("/root/Globals").fire_bullet

var window_size = Vector2(750,750)

var force_shoot = null

func _init():
	rad_x = 0
	rad_x_sign = -1
	rad_y = PI/2
	lives = 3
	maxLives = 3
	action_time_limit = 0.1
	is_paused = false
	
func _ready():
	type = "Player"
	element = "Fire"
	
	myLivesHUD = get_node("../../HUD/FireLives")
	otherPlayer = get_node("../../Entities/FlowerPlayer")
	draw_lives()
	
func _physics_process(_delta):
	if(is_left_click_pressed and action_timer > action_time_limit):
		shoot(fireBullet)
		action_timer = 0

func left_clicked_actions():
	$AnimatedSprite.play("Squeeze")

func left_released_actions():
	$AnimatedSprite.play("Active")

func _on_Fire_area_entered(area):
	if area.element == "Water":
		reduce_lives()
		if(area.destroyed_if_touch_player):
			area.destroy();


func shoot(bullet):
	soundPlayer.get_node("FireShoot_Sound").play()
	var newBullet = bullet.instance()
	newBullet.limit_min = bullet_min
	newBullet.limit_max = bullet_max
	if(force_shoot == null):
		newBullet.init(position, (get_global_mouse_position()-global_position).normalized(), 500, type)
	else:
		newBullet.init(position, Vector2(-1,0), 500, type)
	get_node("../Bullets").add_child(newBullet)

