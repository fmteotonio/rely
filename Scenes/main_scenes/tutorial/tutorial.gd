extends Node2D

var start_blink_timer = 1
var start_blink_time_limit = 0.75

onready var globals = get_node("/root/Globals")

var phase = 0
var phase_timer =      [0,     0,   0, 0,   0, 0,   0,   0, 0,   0, 0,   0,   0, 0,   0, 1,   0,   0,   0, 0,   0,    0]
var phase_time_limit = [0,   999, 999, 1, 999, 0, 999, 999, 1, 999, 0, 999, 999, 1, 999, 1, 999,   1,   1, 1, 999, 9999]
#                       0      1    2  3    4  5    6    7  8  9    0    1    2  3    4, 5,   6,   7,   8, 9,   0,    1]

onready var soundPlayer = get_node("/root/SoundPlayer")
var flamePlayer  = preload("res://Scenes/game_element/player/flame_player/flame_player.tscn")
var flowerPlayer = preload("res://Scenes/game_element/player/flower_player/flower_player.tscn")

onready var fireBullet = globals.fire_bullet

onready var tearEnemyDummy = globals.tear_enemy_normal
onready var spreaderEnemyDummy = globals.spreader_enemy
onready var tearTargetPosition     = get_node("Entities/TearTargetPosition")
onready var spreaderTargetPosition = get_node("Entities/SpreaderTargetPosition")

var flowerPlayer1
var flamePlayer1

var flamePlayer2
var tearEnemyDummy2

var flowerPlayer3
var spreaderEnemyDummy3

var flamePlayer4
var flowerPlayer4

var Panel1_clickedLeft = false
var Panel1_clickedRight = false

func _physics_process(delta):
	phase_timer[phase] += delta
	if(phase_timer[phase] > phase_time_limit[phase]):
		phase += 1
	
	match phase:
		0: pass
		1: 
			$Panel1.visible = true
			flamePlayer1 = flamePlayer.instance()
			flamePlayer1.position = Vector2(10,40)
			flamePlayer1.rad_x = PI/2
			flamePlayer1.rad_y = PI
			flamePlayer1.circle_center = Vector2(40,40)
			flamePlayer1.allow_action = false
			
			flowerPlayer1 = flowerPlayer.instance()
			flowerPlayer1.position = Vector2(70,40)
			flowerPlayer1.rad_x = PI/2
			flowerPlayer1.rad_y = 2*PI
			flowerPlayer1.circle_center = Vector2(40,40)
			flowerPlayer1.allow_action = false

			get_node("Entities").add_child(flamePlayer1)
			get_node("Entities").add_child(flowerPlayer1)
			phase +=1
		2: 
			if(Input.is_action_just_pressed("ui_right")): Panel1_clickedRight = true
			if(Input.is_action_just_pressed("ui_left")):  Panel1_clickedLeft = true
			if(Panel1_clickedRight and Panel1_clickedLeft):
				phase+=1
		3: pass
		4: 
			flamePlayer1.allow_move = false
			flowerPlayer1.allow_move = false
			flamePlayer1.get_node("AnimatedSprite").play("Inactive")
			flowerPlayer1.get_node("AnimatedSprite").play("Inactive")
			phase +=1
		5: pass 
		6:
			$Panel2.visible = true
			flamePlayer2 = flamePlayer.instance()
			
			tearEnemyDummy2 = tearEnemyDummy.instance()
			tearTargetPosition.position = Vector2(0,200)
			
			
			flamePlayer2.position = Vector2(39,182)
			flamePlayer2.circle_center = Vector2(39,183)
			flamePlayer2.rad_x = 0
			flamePlayer2.rad_y = -PI/2
			flamePlayer2.allow_move = false
			flamePlayer2.bullet_min = Vector2(0,109)
			flamePlayer2.bullet_max = Vector2(80,199)
			
			tearEnemyDummy2.position = Vector2(37,122)
			get_node("Entities").add_child(flamePlayer2)
			get_node("Entities").add_child(tearEnemyDummy2)
			tearEnemyDummy2.target = tearTargetPosition
			tearEnemyDummy2.max_speed = 0
			tearEnemyDummy2.speed = 0
			tearEnemyDummy2.shoot_time_limit = INF
			phase +=1
		7:
			if(!get_node("Entities").has_node("TearEnemyNormal")):
				phase+=1
		8: pass
		9: 
			flamePlayer2.allow_action = false
			flamePlayer2.is_left_click_pressed = false 
			flamePlayer2.get_node("AnimatedSprite").play("Inactive")
			phase +=1
		10: pass
		11: 
			$Panel3.visible = true
			flowerPlayer3 = flowerPlayer.instance()
			spreaderEnemyDummy3 = spreaderEnemyDummy.instance()
			
			flowerPlayer3.position = Vector2(112,89)
			flowerPlayer3.allow_move = false
			flowerPlayer3.circle_center = Vector2(111,90)
			flowerPlayer3.rad_x = 0.6
			flowerPlayer3.rad_y = -0.6
			spreaderEnemyDummy3.position = Vector2(180,20)

			get_node("Entities").add_child(flowerPlayer3)
			get_node("Entities").add_child(spreaderEnemyDummy3)
			spreaderEnemyDummy3.bullet_min = Vector2(83,0)
			spreaderEnemyDummy3.bullet_max = Vector2(200,115)
			spreaderTargetPosition.position = spreaderEnemyDummy3.position + Vector2(-1,1)
			spreaderEnemyDummy3.target = spreaderTargetPosition
			spreaderEnemyDummy3.speed = 0
			spreaderEnemyDummy3.max_speed = 0
			spreaderEnemyDummy3.shoot_time_limit = 2
			spreaderEnemyDummy3.shoot_timer = 2
			spreaderEnemyDummy3.shot_speed = 42
			
			phase +=1
		12: 
			if(flowerPlayer3.parried_something):
				phase+=1
		13: pass
		14: 
			flowerPlayer3.allow_action = false
			flowerPlayer3.is_left_click_pressed = false 
			flowerPlayer3.get_node("AnimatedSprite").play("Inactive")
			spreaderEnemyDummy3.is_paused = true
			spreaderEnemyDummy3.get_node("AnimatedSprite").play("Inactive")
			for c in get_node("Entities/Bullets").get_children():
				c.is_paused = true
			phase +=1
		15: pass
		16: 
			$Panel4.visible = true
			flamePlayer4 = flamePlayer.instance()
			flowerPlayer4 = flowerPlayer.instance()
			
			flamePlayer4.position  = Vector2(172,159)
			flamePlayer4.circle_center  = Vector2(173,159)
			flamePlayer4.rad_x = PI/2
			flamePlayer4.allow_action = false
			flamePlayer4.allow_move = false
			flamePlayer4.bullet_min = Vector2(84,121)
			flamePlayer4.bullet_max = Vector2(200,200)
			
			flowerPlayer4.position = Vector2(112,159)
			flowerPlayer4.circle_center = Vector2(111,159)
			flowerPlayer4.rad_x = PI/2
			flowerPlayer4.rad_y = 0
			flowerPlayer4.allow_action = false
			flowerPlayer4.allow_move = false

			flamePlayer4.force_shoot = Vector2(-1,0)
			get_node("Entities").add_child(flamePlayer4)
			get_node("Entities").add_child(flowerPlayer4)
			phase +=1
		17: pass
		18: 
			flamePlayer4.is_left_click_pressed = true
			flamePlayer4.left_clicked_actions()
		19: 
			flamePlayer4.is_left_click_pressed = false
			flamePlayer4.left_released_actions()
		20: 
			flamePlayer4.get_node("AnimatedSprite").play("Inactive")
			flowerPlayer4.get_node("AnimatedSprite").play("Inactive")
			phase +=1
		21:
			start_blink_timer += delta
			if(start_blink_timer > start_blink_time_limit):
				$PressStart_Text.visible = !$PressStart_Text.visible
				start_blink_timer = 0
			if(Input.is_action_just_pressed("ui_start")):
				soundPlayer.get_node("GameStart_Sound").play()
				if get_tree().change_scene(globals.main_path) != OK:
					push_error("Error in change_scene")
					
				
