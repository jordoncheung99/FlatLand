extends Node

signal add_light(light: PointLight2D)
const Pistol = preload("res://Scripts/Player/Pistol.gd")
const PISTOL_BULLET = preload("res://scenes/Pistol_bullet.tscn")
const MUZZLE_FLASH = preload("res://scenes/Player_Systems/muzzle_flash.tscn")

var player_reference : Player
var pistol : Pistol
@onready var sound_player = [$SoundPlayer1, $SoundPlayer2, $SoundPlayer3]
func _ready():
	pistol = Pistol.new()

#no idea how to properly do this so yeah know mash it together
func set_player(player: Player):
	player_reference = player

func _input(_event):
	#This is so jank but... oh well
	if not player_reference.can_move:
		return
	if Input.is_action_pressed("shoot"):
		_fire_pistol()

func _fire_pistol():
	if pistol.shoot():
		_spawn_muzle_flash()
		_spawn_pistol_bullet()
		_play_sound()

func _play_sound():
	var index = randi_range(0,2)
	sound_player[index].play()
	
func _spawn_pistol_bullet():
	var bullet = PISTOL_BULLET.instantiate()
	bullet.spawn(player_reference.global_position, player_reference.rotation)
	#Not sure if this is needed, just add it to a subtree to keep things organized
	$Bullet_Parent.add_child(bullet)
	
#animations handle here because singal munbo jumbo and I CBA
func _spawn_muzle_flash():
	var muzzle = MUZZLE_FLASH.instantiate()
	muzzle.global_position = player_reference.global_position
	add_child(muzzle)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pistol._process(delta)
