extends Node

@onready var base_controller = $BaseContoller
#var player: Player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	#base_controller.set_player(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player(p):
	base_controller.set_player(p)
	#player = p
