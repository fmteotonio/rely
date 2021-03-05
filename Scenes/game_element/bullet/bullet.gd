extends "res://Scenes/game_element/game_element.gd"

var velocity #Must be normalized 2d vector
var speed #Must be int
var is_parried
var shooter_type

var limit_min = Vector2(-10,-10)
var limit_max = Vector2(210,210)

var destroyed_if_touch_player = true

func init(pos,vel,spd,sht_typ):
	position = pos
	velocity = vel
	speed = spd
	shooter_type = sht_typ
	
func _ready():
	type = "Bullet"
	is_parried = false
	print(speed)
	
func _physics_process(delta):
	
	if(!is_paused):
		position += velocity * delta * speed
		if(is_outside_board()):
			destroy()
		
func is_outside_board():
	if(position.x > limit_max.x or position.x < limit_min.x or position.y > limit_max.y or position.y < limit_min.y):
		return true
	else:
		return false

func destroy():
	get_parent().remove_child(self)
	queue_free()
