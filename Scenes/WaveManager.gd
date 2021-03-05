extends Node2D

onready var globals = get_node("/root/Globals")

onready var tearEnemyNormal   = globals.tear_enemy_normal
onready var tearEnemyShielded = globals.tear_enemy_shielded
onready var dropletEnemy      = globals.droplet_enemy
onready var balloonEnemy      = globals.balloon_enemy
onready var spreaderEnemy     = globals.spreader_enemy
onready var tideEnemy         = globals.tide_enemy

onready var hud = get_node("/root/Main/HUD")

onready var curtain = get_node("../../Curtain")

var wave = 0
var wave_index = 0
var loop = 0

var score = 0

var wave_timer
var wave_time_limit
var rest_timer
var rest_time_limit
var time_data

var is_rest = false
var is_paused = false
var is_game_over = false

func setup_all_timers():
	wave_timer =      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	wave_time_limit = [15,40,50,40,50,50,30,50,20,21]
					  # 0  1  2  3  4  5  6  7  8  9
	rest_timer = 0
	rest_time_limit = 3
	time_data = {
		0: {
			dropletEnemy:     {"timer": 0, "time_limit": 1},
		},
		1: {
			tearEnemyNormal:  {"timer": 6, "time_limit": 7},
			dropletEnemy:     {"timer": 0, "time_limit": 1.5},
		},
		2: {
			balloonEnemy:     {"timer": 4, "time_limit": 5},
			dropletEnemy:     {"timer": 0, "time_limit": 1.5},
		},
		3: {
			balloonEnemy:     {"timer": 6, "time_limit": 7},
			tearEnemyNormal:  {"timer": 4, "time_limit": 8},
			dropletEnemy:     {"timer": 2, "time_limit": 4},
		},
		4: {
			tearEnemyShielded: {"timer": 7, "time_limit": 10},
			dropletEnemy:     {"timer": 0, "time_limit": 1.3},
		},
		5: {
			spreaderEnemy:    {"timer": 12, "time_limit": 11.5},
			dropletEnemy:     {"timer": 0, "time_limit": 2.2},
		},
		6: {
			tearEnemyShielded: {"timer": 7, "time_limit": 4.4},
		},
		7: {
			balloonEnemy:     {"timer": 0, "time_limit": 7},
			tearEnemyShielded: {"timer": 12, "time_limit": 13.4},
			dropletEnemy:     {"timer": 0, "time_limit": 2.6},
		},
		8: {
			balloonEnemy:     {"timer": 5, "time_limit": 2.1},
		},
		9: {
			tideEnemy:        {"timer": 999, "time_limit": 999},
		}
	}
	for w in time_data:
		for enemy in time_data[w]:
			time_data[w][enemy]["time_limit"] -= time_data[w][enemy]["time_limit"]*0.15*loop

func _ready():
	randomize()
	globals.real_game = true
	setup_all_timers()
	
	if curtain.connect("curtain_closed", self, "_on_curtain_closed") != OK:
		print("Connection has failed")
	

func _physics_process(delta):
	if(!is_paused):
		if(is_rest):
			rest_timer += delta
			if(rest_timer > rest_time_limit):
				is_rest = false
				rest_timer = 0
				update_wave()
		else:
			wave_timer[wave_index] += delta
			if(wave_timer[wave_index] > wave_time_limit[wave_index]):
				is_rest = true
			for enemy in time_data[wave_index]:
				time_data[wave_index][enemy]["timer"] += delta
				if(time_data[wave_index][enemy]["timer"] > time_data[wave_index][enemy]["time_limit"]):
					var newEnemy = enemy.instance()
					get_parent().add_child(newEnemy)
					newEnemy.position = get_random_starting_vector(newEnemy)
					time_data[wave_index][enemy]["timer"] = 0
	else:
		if(is_game_over):
			if(Input.is_action_just_pressed("ui_start")):
				globals.first_time_playing = false
				curtain.get_node("AnimatedSprite").play("Close")
				

func _on_curtain_closed():
	if get_tree().change_scene(globals.titlescreen_path) != OK:
		push_error("Error in change_scene")

func update_wave():
	wave_timer[wave_index] = 0
	wave += 1
	wave_index += 1
	if(wave_index >= wave_timer.size()):
		setup_all_timers()
		wave_index = 1
		loop += 1
	SoundPlayer.get_node("WaveClear_Sound").play()
	set_wave()
	
func set_wave():
	var waveNumber = hud.get_node("TextElements/WaveNumber")
	waveNumber.text = (wave+1) as String
	waveNumber.margin_left = waveNumber.initial_margin_left - 4*number_of_digits(wave+1) + 4
	
	
func update_score(value):
	var scoreNumber = hud.get_node("TextElements/ScoreNumber")
	score += value
	scoreNumber.text = score as String
	scoreNumber.margin_left = scoreNumber.initial_margin_left - 4*number_of_digits(score+1) + 4

func number_of_digits(i):
	if( i == 0 ):
		return 1
	else:
		return floor((log(i)/log(10)) + 1)
	

func get_random_starting_vector(enemy):
	var dir = randi() % 4
	var pos = randi() % 101
	if(enemy.enemyId != "TideEnemy"):
		match dir:
			0: return Vector2(pos,-3)
			1: return Vector2(203,pos)
			2: return Vector2(pos,203)
			3: return Vector2(-3, pos)
	else:
		match dir:
			0: return Vector2(-5,-5)
			1: return Vector2(205,205)
			2: return Vector2(-5,205)
			3: return Vector2(205,-5)
