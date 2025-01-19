extends Node

@onready var DoorRight: StaticBody2D = $DoorHalfRight 
@onready var DoorLeft: StaticBody2D = $DoorHalfLeft
@onready var audo_player = $AudioStreamPlayer2D
var speed: float = 1
var max_open: float = 24
@export var state_open: bool = false
var direction_vector: Vector2 = Vector2(1,0)

func _physics_process(delta):
	_limit_door(DoorRight, state_open, state_open)
	_limit_door(DoorLeft, state_open, not state_open)
	
func _limit_door(Door: StaticBody2D, open: bool, direction: bool):
	var factor = 1
	if not direction:
		factor = -1
	var dir_vector = direction_vector * factor
	if not open:
		if(Door.transform.origin.length() >= 0.1):
			Door.transform.origin += dir_vector
			#print(Door.transform.origin.length())
			#Door.move_and_collide(dir_vector)
	else:
		if(Door.transform.origin.abs().length() <= max_open):
			Door.transform.origin += dir_vector
			#print(dir_vector)
			#Door.move_and_collide(dir_vector)
		

func _on_button_trigger_button():
	state_open = not state_open
	audo_player.play()
