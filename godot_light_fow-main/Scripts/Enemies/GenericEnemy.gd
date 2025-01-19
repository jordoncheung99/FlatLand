extends CharacterBody2D

var health: int = 3
var speed: float = 100
var player: Player = null

@onready var hit_splat_scene = preload("res://scenes/Enemies/HitSplat.tscn")

func damage(damage_ammount: int):
	health -= damage_ammount
	if (health <= 0):
		queue_free()

func set_player(player_ref: Player):
	player = player_ref
