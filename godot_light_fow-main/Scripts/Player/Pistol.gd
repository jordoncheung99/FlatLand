extends Node

var current_cooldown: float = 0
var cooldown: float = 0.5
#honestly no clue if this is more optimal
var can_fire: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_fire:
		return
	current_cooldown += delta
	if(current_cooldown > cooldown):
		can_fire = true

#return if a shot was fire for effects
func shoot() -> bool:
	if not can_fire:
		return false
	can_fire = false
	current_cooldown = 0
	return true
