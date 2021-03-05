extends "res://Scenes/game_element/player/player.gd"

var parry_charged = true
var is_parrying = false
var parried_something = false

func _init():
	rad_x = 0
	rad_x_sign = 1
	rad_y = -PI/2
	lives = 3
	maxLives = 3
	is_paused = false
	
func _ready():
	type = "Player"
	element = "Water"
	
	myLivesHUD = get_node("../../HUD/FlowerLives")
	otherPlayer = get_node("../../Entities/FlamePlayer")
	draw_lives()

func _on_Flower_area_entered(area):
	if area.element == "Water" and area.type == "Bullet" and !area.is_parried and is_parrying:
		soundPlayer.get_node("Reflect_Sound").play()
		area.velocity = -area.velocity
		area.speed *= 2
		area.is_parried = true
		parried_something = true
	if area.element == "Water" and area.type == "Enemy" and is_parrying:
		soundPlayer.get_node("Reflect_Sound").play()
		area.speed *= -1
	if area.element == "Fire":
		reduce_lives()
		if(area.destroyed_if_touch_player):
			area.destroy();

func right_clicked_actions():
	if(parry_charged):
		parry()

func right_released_actions():
	.right_released_actions()

func parry():
	if(parry_charged):
		soundPlayer.get_node("FlowerParry_Sound").play()
		$AnimatedSprite.play("Active_Grow")
		$BigCollision.disabled = false
		$SmallCollision.disabled = true
		parry_charged = false
		is_parrying = true

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Active_Grow":
		$AnimatedSprite.play("Active_Shrink")
		$BigCollision.disabled = true
		$SmallCollision.disabled = false
		is_parrying = false
		return
	if $AnimatedSprite.animation == "Active_Shrink":
		parry_charged = true
		$AnimatedSprite.play("Active")
		
