extends Node2D
signal on_light_moved(light_id: int, position: Vector2)
@export var level: int = 1

func _ready():
	var player = get_node("Player")
	$GunSystem.set_player(player)
	$OtherStuff/EnemySystem.set_player(player)
	var level_string = "res://scenes/Levels/Level" + str(level) + ".tscn"
	player._set_level_restart(level_string)
#
func _input(_event):
	if Input.is_action_pressed("Level1"):
		get_tree().change_scene_to_file("res://scenes/Levels/Level1.tscn")
	elif Input.is_action_pressed("Level2"):
		get_tree().change_scene_to_file("res://scenes/Levels/Level2.tscn")
	elif Input.is_action_pressed("Level3"):
		get_tree().change_scene_to_file("res://scenes/Levels/Level3.tscn")
	elif Input.is_action_pressed("Level4"):
		get_tree().change_scene_to_file("res://scenes/Levels/Level4.tscn")
	elif Input.is_action_pressed("Level5"):
		get_tree().change_scene_to_file("res://scenes/Levels/Level5.tscn")
