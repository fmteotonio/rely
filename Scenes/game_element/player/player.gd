extends "res://Scenes/game_element/game_element.gd"

var myLivesHUD

onready var soundPlayer = get_node("/root/SoundPlayer")
onready var main_camera = get_node("../../MainCamera")
var otherPlayer

var allow_move = true
var allow_action = true

var circle_center = Vector2(100,100)

var rad_x
var rad_y
var rad_x_sign

var lives
var maxLives

var action_timer = 0
var action_time_limit

var bullet_min = Vector2(-3,-3)
var bullet_max = Vector2(253,253)

var is_left_click_pressed = false
var is_right_click_pressed = false

var invincibility_time_limit = 2
var invincibility_timer = 0
var invincibility = false
var invincibility_hide_time_limit = 0.05
var invincibility_hide_timer = 0

onready var speed = 1

func _physics_process(delta):
	
	if(!is_paused):

		action_timer += delta
		
		check_invincibility(delta)
		check_animation_direction()
		
		if(allow_move):
			if(Input.is_action_pressed("ui_right")):
				soundPlayer.get_node("PlayerMove_Sound").play()
				rad_x += delta*PI*speed
				rad_y += delta*PI*speed
			elif(Input.is_action_pressed("ui_left")):
				soundPlayer.get_node("PlayerMove_Sound").play()
				rad_x -= delta*PI*speed
				rad_y -= delta*PI*speed
			else:
				soundPlayer.get_node("PlayerMove_Sound").stop()
		#	if(Input.is_action_just_pressed("ui_shift")):
		#		rad_x += PI
		#		rad_y += PI
			move()

func _input(event):
	if(!is_paused && allow_action):
		if (left_clicked(event)):  
			is_left_click_pressed = true
			left_clicked_actions()
		if (left_released(event)): 
			is_left_click_pressed = false 
			left_released_actions()
		if (right_clicked(event)):
			is_right_click_pressed = false 
			right_clicked_actions()
		if (right_released(event)):
			is_right_click_pressed = false 
			right_released_actions()

func left_clicked_actions():
	pass

func left_released_actions():
	pass
	
func right_clicked_actions():
	pass

func right_released_actions():
	pass

func move():
	position.x = circle_center.x + rad_x_sign*sin(rad_x)*30
	position.y = circle_center.y + sin(rad_y)*30

func player_action():
	#Defined in the subclasses
	pass
	

func check_invincibility(delta):
	if(invincibility_timer > invincibility_time_limit):
		invincibility = false
		invincibility_timer = 0
		$AnimatedSprite.visible = true
	if(invincibility):
		invincibility_timer += delta
		if(invincibility_hide_timer > invincibility_hide_time_limit):
			$AnimatedSprite.visible = !$AnimatedSprite.visible
			invincibility_hide_timer = 0
		invincibility_hide_timer += delta

func check_animation_direction():
	var actives = ["Active","Active-Right","Active-Left",
				   "Active-Up", "Active-UpRight", "Active-UpLeft",
				   "Active-Down", "Active-DownRight", "Active-DownLeft",
				]
	if(actives.has($AnimatedSprite.animation)):
		if(sin(rad_y) < 0.4 and sin(-rad_x*rad_x_sign) >= -0.4 and sin(-rad_x*rad_x_sign) < 0.4):
			$AnimatedSprite.play("Active-Up")
		if(sin(rad_y) < 0.4 and sin(-rad_x*rad_x_sign) < -0.4):
			$AnimatedSprite.play("Active-UpRight")
		if(sin(rad_y) < 0.4 and sin(-rad_x*rad_x_sign) >= 0.4):
			$AnimatedSprite.play("Active-UpLeft")		
			
		if(sin(rad_y) > -0.4 and sin(rad_y) < 0.4 and sin(-rad_x*rad_x_sign) < -0.4):
			$AnimatedSprite.play("Active-Right")
		if(sin(rad_y) > -0.4 and sin(rad_y) < 0.4 and sin(-rad_x*rad_x_sign) >= 0.4):
			$AnimatedSprite.play("Active-Left")		
			
		if(sin(rad_y) >= 0.4 and sin(-rad_x*rad_x_sign) >= -0.4 and sin(-rad_x*rad_x_sign) < 0.4):
			$AnimatedSprite.play("Active-Down")
		if(sin(rad_y) >= 0.4 and sin(-rad_x*rad_x_sign) < -0.4):
			$AnimatedSprite.play("Active-DownRight")
		if(sin(rad_y) >= 0.4 and sin(-rad_x*rad_x_sign) >= 0.4):
			$AnimatedSprite.play("Active-DownLeft")	

func reduce_lives():
	if(!invincibility):
		main_camera.shake(0.2, 15, 8)
		invincibility = true
		soundPlayer.get_node("PlayerHit_Sound").play()
		lives -= 1
		draw_lives()
		if(lives == 0):
			$AnimatedSprite.play("Inactive")
			otherPlayer.get_node("AnimatedSprite").play("Sad")
			soundPlayer.get_node("GameOver_Sound").play()
			get_node("/root/Main/TextGameOver").visible = true
			for entity in get_parent().get_children():
				if(entity.name != "Bullets"): entity.is_paused = true
				if(entity.name == "WaveManager"): entity.is_game_over = true
			for entity in get_parent().get_node("Bullets").get_children():
				entity.is_paused = true
				

func draw_lives():
	for i in range(1,maxLives+1,1):
		if(i > lives): myLivesHUD.get_node("Heart" + i as String).hide()
		else:          myLivesHUD.get_node("Heart" + i as String).show()

func left_clicked(event):
	return event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT
	
func left_released(event):
	return event is InputEventMouseButton and !event.is_pressed() and event.button_index == BUTTON_LEFT
	
func right_clicked(event):
	return event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT
	
func right_released(event):
	return event is InputEventMouseButton and !event.is_pressed() and event.button_index == BUTTON_RIGHT
