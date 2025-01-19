extends Node

enum {
	UNAWARE,
	DELAYED,
	AWARE
}
var state = UNAWARE
var player: Player = null
@onready var los = $LineOfSight



func _physics_process(delta):
	if state == UNAWARE and player and check_ray_in_range(los):
		state = AWARE
		#turn off since it's no longer needed
		los.enabled = false
	
func set_player(player_ref: Player):
	player = player_ref

func check_ray_in_range(ray: RayCast2D) -> bool:
	ray.look_at(player.global_position)
	var collider = ray.get_collider()
	if collider and collider == player:
		return true
	return false
	
