extends Node2D

const SpitterBullet = preload("res://scenes/Enemies/SpitterBullet.tscn")
var player: Player = null
var node_number = 0
#Hard coded jank
const number_of_nodes = 60
var node_fraction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire(fire_mode: int):
	_spawn_bullet(fire_mode)
	pass

func set_player(p: Player, node: int):
	player = p
	node_number = node
	#use 1.0 to convert to float
	node_fraction = (node_number + 1.0) / number_of_nodes

func two_mode():
	var plus_1 = node_number + 1
	if plus_1 <= 8 or plus_1 >= 54:
		#Stright down
		return PI / 2
	if  9 <= plus_1 and plus_1 <= 23:
		#Left
		return PI 
	if  24 <= plus_1 and plus_1 <= 38:
		#Up
		return 3 * PI / 2
	else:
		return 0 

func up_down():
	var plus_1 = node_number + 1
	if plus_1 <= 16 or plus_1 >= 46:
		#Stright down
		return PI / 2
	else:
		return 3 * PI / 2

func left_right():
	var plus_1 = node_number + 1
	if plus_1 >= 32:
		return 0
	else:
		return PI
	

func get_angle(fire_mode: int):
	match fire_mode:
		#At players
		0:
			return global_position.direction_to(player.global_position).angle()
		#Stright across
		1:
			var adjustment = PI/2 + (2 * PI * node_fraction )
			return adjustment
		#Horizontal/Vertical
		2:
			return two_mode()
		#Down/Up
		3:
			return up_down()
		#Left/Right
		4:
			return left_right()
		5:
			return up_down()
		6:
			return left_right()
func _spawn_bullet(fire_mode: int):
	var bullet = SpitterBullet.instantiate()
	var angle_to_fire = get_angle(fire_mode)	
	bullet.spawn(global_position, angle_to_fire)
	if fire_mode == 5 || fire_mode == 6:
		bullet.light.enabled = false
	get_node("..").add_sibling(bullet)
