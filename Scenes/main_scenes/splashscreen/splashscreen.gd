extends Node2D

onready var globals = get_node("/root/Globals")
onready var soundPlayer = get_node("/root/SoundPlayer")

var author_timer = 0
var author_time_limit = 1.5



func _ready():
	if $Curtain.connect("curtain_closed", self, "_on_curtain_closed") != OK:
		print("Connection has failed")
	soundPlayer.get_node("Splash_Sound").play()

func _physics_process(delta):
	author_timer += delta
	if(author_timer > author_time_limit):
		$Curtain.get_node("AnimatedSprite").play("Close")

func _on_curtain_closed():
	if get_tree().change_scene(globals.titlescreen_path) != OK:
		push_error("Error in change_scene")
	
