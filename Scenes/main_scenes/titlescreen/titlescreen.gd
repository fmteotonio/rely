extends Node2D

var start_blink_timer = 0
var start_blink_time_limit = 0.75

onready var globals = get_node("/root/Globals")
onready var soundPlayer = get_node("/root/SoundPlayer")

func _ready():
	$Curtain.get_node("AnimatedSprite").play("Open")

func _physics_process(delta):
		start_blink_timer += delta
		if(start_blink_timer > start_blink_time_limit):
			$PressStart_Text.visible = !$PressStart_Text.visible
			start_blink_timer = 0
		if(Input.is_action_just_pressed("ui_start")):
			if(globals.first_time_playing):
				soundPlayer.get_node("TutorialStart_Sound").play()
				if get_tree().change_scene(globals.tutorial_path) != OK:
					push_error("Error in change_scene")
			else:
				soundPlayer.get_node("GameStart_Sound").play()
				if get_tree().change_scene(globals.main_path) != OK:
					push_error("Error in change_scene")
