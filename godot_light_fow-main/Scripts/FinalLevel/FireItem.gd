
class_name FireItem

var nodes_to_fire = []
var time_to_fire: float = 0
var fire_mode:int = 0

func set_fire(nodes, time, mode):
	nodes_to_fire = nodes
	time_to_fire = time
	fire_mode = mode

func __lt__(other):
	print("sorting")
	return time_to_fire < other.time_to_fire
