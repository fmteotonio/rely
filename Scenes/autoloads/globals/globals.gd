extends Node

const titlescreen_path = "res://Scenes/main_scenes/titlescreen/titlescreen.tscn"
const tutorial_path    = "res://Scenes/main_scenes/tutorial/tutorial.tscn"
const main_path        = "res://Scenes/main_scenes/main.tscn"


const fire_bullet         = preload("res://Scenes/game_element/bullet/fire_bullet/fire_bullet.tscn")
const water_bullet        = preload("res://Scenes/game_element/bullet/water_bullet/water_bullet.tscn")

const small_explosion_particle = preload("res://Scenes/visuals/particle/small_explosion_particle/small_explosion_particle.tscn")
const enemy_flash_particle     = preload("res://Scenes/visuals/particle/enemy_flash_particle/enemy_flash_particle.tscn")

const droplet_enemy       = preload("res://Scenes/game_element/enemy/droplet_enemy/droplet_enemy.tscn")
const tear_enemy_normal   = preload("res://Scenes/game_element/enemy/tear_enemy/tear_enemy_normal/tear_enemy_normal.tscn")
const tear_enemy_shielded = preload("res://Scenes/game_element/enemy/tear_enemy/tear_enemy_shielded/tear_enemy_shielded.tscn")
const balloon_enemy       = preload("res://Scenes/game_element/enemy/balloon_enemy/balloon_enemy.tscn")
const spreader_enemy      = preload("res://Scenes/game_element/enemy/spreader_enemy/spreader_enemy.tscn")

const tide_enemy          = preload("res://Scenes/game_element/enemy/tide_enemy/tide_enemy.tscn")

var real_game          = false
var first_time_playing = true
