extends "res://Scenes/game_element/game_element.gd"


onready var globals      = get_node("/root/Globals")
onready var soundPlayer  = get_node("/root/SoundPlayer")
onready var flamePlayer  = get_node("../FlamePlayer")
onready var flowerPlayer = get_node("../FlowerPlayer")
onready var waveManager  = get_node("../WaveManager")

onready var SmallExplosionParticle = globals.small_explosion_particle
onready var EnemyFlashParticle     = globals.enemy_flash_particle

var enemyId

var max_hp
var max_speed
var acceleration
var score
var target

var bullet_min = Vector2(-3,-3)
var bullet_max = Vector2(253,253)

var hp
var speed

var destroyed_if_touch_player = true

var is_shooting = false

func _ready():
	type = "Enemy"
	target = flamePlayer

func _physics_process(delta):
	if(!is_paused):
		var move_direction = (target.position - position).normalized()
		if (speed < max_speed):
			speed += acceleration * delta
		position += move_direction * delta * speed
		check_animation(move_direction)
		
func check_animation(direction):
	if(!is_shooting):
		if(direction.x >= 0 and direction.y >= 0): $AnimatedSprite.play("Active-DownRight")
		if(direction.x <  0 and direction.y >= 0): $AnimatedSprite.play("Active-DownLeft")
		if(direction.x <  0 and direction.y <  0): $AnimatedSprite.play("Active-UpLeft")
		if(direction.x >= 0 and direction.y <  0): $AnimatedSprite.play("Active-UpRight")

func reduce_hp():
	soundPlayer.get_node("EnemyHit_Sound").play()
	var enemy_flash_particle = EnemyFlashParticle.instance()
	enemy_flash_particle.get_node("AnimatedSprite").play(enemyId)
	add_child(enemy_flash_particle)
	hp -= 1
	if(hp==0):
		destroy()
		
func destroy():
	if(globals.real_game):
		waveManager.update_score(score)
	var small_explosion_particle = SmallExplosionParticle.instance()
	small_explosion_particle.position = position
	get_parent().add_child(small_explosion_particle)
	soundPlayer.get_node("EnemyDeath_Sound").play()
	get_parent().remove_child(self)
	queue_free()
	

