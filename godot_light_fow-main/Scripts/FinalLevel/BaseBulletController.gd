extends Node
#const fire_item = preload("res://Scripts/FinalLevel/FireItem.gd")
var time_elapsed = 0
var current_index = 0
signal ending_text
var set_once = false
#Defines the number of nodes that can be fired
const num_nodes = 60
# Nodes to fire [], fire mode, time to fire
# Called when the node enters the scene tree for the first time.
var master_fire_list = []
var player: Player

func create_item(array: Array, time: float, mode: int):
	var instance = FireItem.new()
	#var instance = fire_item.new()
	instance.set_fire(array, time, mode)
	return instance	

func check_is_ready(index: int):
	if index >= len(master_fire_list):
		return false

	var tmp: FireItem = master_fire_list[index]
	if tmp.time_to_fire <= time_elapsed:
		return true
	return false

func advance(time_elapsed):
	while check_is_ready(current_index):
		fire_node(master_fire_list[current_index])
		current_index += 1
	#removing from the front of an array is bad but it works
	pass

func fire_node(item: FireItem):
	for node in item.nodes_to_fire:
		var index = node % num_nodes
		var firing_node = get_child(index)
		firing_node.fire(item.fire_mode)

func _ready():
	set_master_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	advance(time_elapsed)
	if not set_once and time_elapsed >= 330:
		set_once = true
		set_ending_text()

func set_ending_text():
	const failure_text = "My message is only for those who mastered this, score 50 or less to proceed. Shift-R to restart the level"
	const victory_text = "Those who I played with are my greatest friends to this day, it has earned me a nickname that I go by that confuses all who know me. The perseverance to chug throughout the night only to be barely functional but holding the key in my hand is a memory I will not forget. One day I dream that some intern I manage will tell me about their experience of some crazy puzzle and solution they had to come up with. - Jordon"
	const cheater_text = "I don't believe you obtained this score. You must of cheated or something"
	if player.hit_count <= 10:
		ending_text.emit(cheater_text)
	elif player.hit_count <= 50:
		ending_text.emit(victory_text)
	else:
		ending_text.emit(failure_text)
	

func set_player(p: Player):
	player = p
	set_all_nodes(p)

func set_all_nodes(player: Player):
	for node in get_children():
		node.set_player(player, node.get_index())
		
func append_quad(start_index: int, start_time:float, delay:float):
	for i in range(4):
		var index = (start_index + i * num_nodes / 4) % num_nodes
		var time = start_time + i * delay
		master_fire_list.append(create_item([index], time, 0))

func reverse_rotating_duel(start_index: int, start_time: float, length:float, delay:float, fire_mode: int):
	var times = length / delay
	var half_nodes = num_nodes / 2
	for i in range(int(times)):
		var index = 0
		if i % 2 == 0:
			index = start_index - i * 3
		else:
			index = start_index - (i-1) * 3 - half_nodes
		index = index % num_nodes
		var fire_time = start_time + delay * i
		master_fire_list.append(create_item([index], fire_time, fire_mode))

func rotating_duel(start_index: int, start_time: float, length:float, delay:float, fire_mode: int):
	var times = length / delay
	var half_nodes = num_nodes / 2
	for i in range(int(times)):
		var index = 0
		if i % 2 == 0:
			index = start_index + i * 3
		else:
			index = start_index + (i-1) * 3 + half_nodes
		index = index % num_nodes
		var fire_time = start_time + delay * i
		master_fire_list.append(create_item([index], fire_time, fire_mode))

func add_quad_simult(start_index:int, start_time: float, repeats: int, delay:float, fire_mode: int):
	var adder = 40
	for i in range(repeats):
		var index = (start_index + i * adder) % num_nodes
		var time = start_time + i * delay
		for j in range(4):
			var temp_index = index + j * 15
			master_fire_list.append(create_item([temp_index], time, fire_mode))

func add_stright(start_index:int, start_time: float, repeats: int, delay:float, direction: int):
	#left
	const adder = 9
	const range = 14
	var off_set = 0
	match direction:
		#Down
		0:
			off_set = 54
		#Right
		1:
			off_set = 9
		#Left
		2:
			off_set = 24
		#Right
		3:
			off_set = 39
	
	for i in range(repeats):
		var index = (start_index + i * adder) % range + off_set
		var time = start_time + i * delay
		master_fire_list.append(create_item([index], time, 2))

func add_circle(start_index:int, start_time:float, repeats: int, delay:float, fire_mode:int, clockwise: bool):
	for i in range(repeats):
		var adder = i
		if not clockwise:
			adder = -adder 
		var index = (start_index + adder) % num_nodes
		var time = start_time + i * delay
		master_fire_list.append(create_item([index], time, fire_mode))

func add_slit(start_time:float, slit_index: int, horizontal: bool):
	var array = range(0,num_nodes)
	var slit_array
	var fire_mode
	if horizontal:
		slit_array = [14,15,16,44,45,46,59,0,1,3,5,57,55,29,30,31,33,35,27,25]
		fire_mode = 4
	else:
		slit_array = [0,1,59,31,30,29,46,45,44,43,41,39,48,50,10,12,14,15,16,18,20]
		fire_mode = 3
	for i in slit_array:
		array.erase(i)
	for i in array:
		for j in range(0,5):
			master_fire_list.append(create_item([i], start_time + 0.15 * j, fire_mode))

func add_beam(start_index:int, start_time:float, repeats: int, delay:float, fire_mode:int):
	for i in repeats:
		master_fire_list.append(create_item([start_index], start_time + delay * i, fire_mode))

func add_spiral(start_time:float):
	#Being lazy about it, to reset it to 0 - 10 from start time
	start_time -= 10
	add_beam(0, 10+start_time,5, 0.1, 3)
	var num_shots = 5
	add_circle(0, 10+start_time,num_shots,0.2,1,true)
	add_circle(15, 10+start_time,num_shots,0.2,1,true)
	add_circle(30, 10+start_time,num_shots,0.2,1,true)
	add_circle(45, 10+start_time,num_shots,0.2,1,true)
	
	add_beam(15, 12+start_time,5, 0.1, 4)
	add_circle(7, 12+start_time,num_shots,0.2,1,false)
	add_circle(22, 12+start_time,num_shots,0.2,1,false)
	add_circle(37, 12+start_time,num_shots,0.2,1,false)
	add_circle(52, 12+start_time,num_shots,0.2,1,false)
	
	add_beam(30, 13.7+start_time,5, 0.1, 3)
	add_circle(0, 13.7+start_time,num_shots,0.2,1,true)
	add_circle(15, 13.7+start_time,num_shots,0.2,1,true)
	add_circle(30, 13.7+start_time,num_shots,0.2,1,true)
	add_circle(45, 13.7+start_time,num_shots,0.2,1,true)
	
	add_beam(45, 15.6+start_time,5, 0.1, 4)
	add_circle(7, 15.6+start_time,num_shots,0.2,1,false)
	add_circle(22, 15.6+start_time,num_shots,0.2,1,false)
	add_circle(37, 15.6+start_time,num_shots,0.2,1,false)
	add_circle(52, 15.6+start_time,num_shots,0.2,1,false)

func add_chaos(start_time: float, repeats: int):
	for i in range(repeats):
		var index = (i * 18) % num_nodes
		var time = start_time + i * 0.5
		rotating_duel(index,time, 0.6, 0.2, 0)
		
func add_rain(start_index:int, start_time: float, repeats: int, delay: float, reverse:bool):
	var array = []
	for i in range(0,num_nodes):
		#if i > 18 and i < 47:
			#array.erase(i) 
		if i <= 15 or i >= 47:
			array.append(i)
	var length = len(array)
	var adder = 7
	if reverse:
		adder = adder * -1
	for i in range(repeats):
		var index = (start_index + adder * i) % length
		master_fire_list.append(create_item([array[index]], start_time + delay * i, 3))

func add_doot_doot(start_time: float, repeat: int, delay: float):
	var array = [0, 15, 30, 45]
	for i in range(repeat):	
		var index = array[i % 4]
		var time = start_time + i * delay
		add_beam(index, time, 1, 0.05, 0)

func add_repeaters(start_index: int, start_time: float, num_shots: int, delay: float):
	for i in range(num_shots):
		var time = start_time + i * delay
		add_beam(start_index, time, 1,0,0)
func add_intro():
	append_quad(0, 16.5, 0.3)
	append_quad(7, 20.2, 0.3)
	append_quad(3, 24.1, 0.3)
	append_quad(11, 27.7, 0.3)
	append_quad(1, 31.3, 0.3)
	append_quad(8, 33.1, 0.3)
	append_quad(12, 35.1, 0.3)
	append_quad(4, 37, 0.3)
	append_quad(2, 38, 0.3)
	append_quad(7, 38.8, 0.3)
	append_quad(13, 40.6, 0.3)
	append_quad(9, 42.5, 0.3)
	rotating_duel(0,44.2,1,0.1, 0)
	
func add_first():
	add_quad_simult(0,46.3,4,1.8,1)
	add_quad_simult(40,52.8,1,0,1)
	
	add_quad_simult(20,53.6,4,1.8,1)
	add_quad_simult(0,60,1,0,1)
	rotating_duel(12,46.2,14.8,0.4, 0)
	rotating_duel(15,61,5,0.2, 0)
	
	add_stright(12,66.1,5,0.3,0)
	add_stright(12,66.3,4,0.3,1)
	add_stright(12,66.5,4,0.3,2)
	add_stright(12,66.7,3,0.3,3)
	
func add_second():
		# +68
		const adder = 68
		add_quad_simult(0,0.3+adder,1,0,0)
		add_quad_simult(0,2.35+adder,3,0.4,0)
		rotating_duel(30,4+adder,2.6,0.2,0)
		add_circle(30, 6.8+adder,20,0.05,1,true)
		add_stright(0, 8.8+adder, 2, 0.1, 0)
		add_stright(0, 9.2+adder, 2, 0.1, 1)
		add_stright(0, 9.6+adder, 2, 0.1, 2)
		add_stright(0, 10+adder, 2, 0.1, 3)
		add_stright(0, 11+adder, 15, 0.2, 3)
		add_stright(3, 11.2+adder, 15, 0.2, 3)
		add_stright(0, 15+adder, 12, 0.3, 0)
		add_stright(0, 15.2+adder, 11, 0.3, 1)
		add_circle(45, 18.8+adder,20,0.05,1,true)
		add_circle(15, 20.8+adder,18,0.05,1,true)
		add_circle(50, 21.8+adder,18,0.05,1,false)
		
		rotating_duel(30,23.5+adder,1.4,0.2,0)
		rotating_duel(7,26+adder,3.8,0.2,0)
		
		rotating_duel(0,30+adder,4,0.4,0)
		rotating_duel(15,30.4+adder,3,0.4,2)
		
		add_circle(0, 33.8+adder,20,0.05,1,true)
		add_circle(30, 35.7+adder,18,0.05,1,true)
		add_circle(15, 36.6+adder,18,0.05,1,false)
		
func add_break_one():
	#-106
	var adder = 106
	add_stright(12,1.15+adder,50,0.62,0)
	add_stright(0,14.15+adder,30,0.62,1)
	add_stright(7,21.43+adder,20,0.62,2)
	rotating_duel(45,29.7+adder,4.2,0.6, 0)
	add_circle(28, 34+adder,6,0.05,1,false)
	rotating_duel(45,37+adder,4.2,0.6, 0)
	rotating_duel(18,40.7+adder,1.2,0.6, 0)
	rotating_duel(30,42+adder,2.4,0.6, 0)
	rotating_duel(50,44.5+adder,4.8,0.6, 0)
	add_circle(48, 48.8+adder,6,0.05,1,true)
	rotating_duel(0,51.8+adder,2.4,0.6, 0)
	add_slit(54.7+adder,0,false)

func add_third():
	var adder = 162
	rotating_duel(3,2.4+adder, 3.4, 0.2, 3)
	rotating_duel(13,2.4+adder, 3.4, 0.2, 3)
	rotating_duel(17,2.4+adder, 2.2, 0.2, 3)

	rotating_duel(3,4.7+adder, 3.6, 0.2, 4)
	rotating_duel(13,4.7+adder, 3.6, 0.2, 4)
	rotating_duel(17,4.7+adder, 3.6, 0.2, 4)
	
	add_spiral(10+adder)

	rotating_duel(3,17.2+adder, 3.4, 0.2, 3)
	rotating_duel(13,17.2+adder, 3.4, 0.2, 3)
	rotating_duel(17,17.2+adder, 2.2, 0.2, 3)

	rotating_duel(3,19.5+adder, 3.6, 0.2, 4)
	rotating_duel(13,19.5+adder, 3.6, 0.2, 4)
	rotating_duel(17,19.5+adder, 3.6, 0.2, 4)
	
	add_spiral(24.8+adder)
	
	add_circle(0, 32+adder,3,0.2,0,false)
	add_circle(30, 32.6+adder,3,0.2,0,false)
	add_circle(15, 33.2+adder,3,0.2,0,false)
	add_circle(45, 33.8+adder,3,0.2,0,false)
	add_circle(7, 34.4+adder,3,0.2,0,false)
	add_circle(22, 35+adder,3,0.2,0,false)
	add_circle(37, 35.6+adder,3,0.2,0,false)
	add_circle(52, 36.6+adder,3,0.2,0,false)
	add_circle(0, 37.2+adder,3,0.2,0,false)
	#0.4 between
	add_circle(30, 37.6+adder,3,0.2,0,false)
	add_circle(15, 38+adder,3,0.2,0,false)
	add_circle(45, 38.4+adder,3,0.2,0,false)
	add_circle(7, 38.8+adder,2,0.2,0,false)
	add_circle(22, 39.2+adder,2,0.2,0,false)
	add_circle(37, 39.6+adder,2,0.2,0,false)
	#back to 0.6
	add_circle(52, 40.2+adder,3,0.2,0,false)
	add_circle(0, 40.8+adder,3,0.2,0,false)
	#add_circle(30, 41.4+adder,3,0.2,0,false)
	#add_circle(15, 42+adder,3,0.2,0,false)
	
	rotating_duel(30,42.5+adder, 0.6, 0.05, 0)
	
	add_chaos(46.4+adder,15)
	#54 - 57.9
	add_circle(0, 54+adder,3,0.2,0,false)
	add_circle(30, 54.55+adder,3,0.2,0,false)
	add_circle(15, 55.1+adder,3,0.2,0,false)
	add_circle(45, 55.65+adder,3,0.2,0,false)
	add_circle(7, 56.2+adder,3,0.2,0,false)
	add_circle(22, 56.75+adder,3,0.2,0,false)
	add_circle(37, 57.3+adder,3,0.2,0,false)
	
	add_circle(37, 57.9+adder,30,0.05,0,false)

func add_third_pt2():
	#222
	const adder = 222
	const num_shots = 15
	add_beam(0, 0.6+adder, num_shots, 0.1, 0)
	add_beam(30, 1.5+adder, num_shots, 0.1, 0)
	add_beam(15, 2.6+adder, num_shots, 0.1, 0)
	add_beam(45, 3.5+adder, num_shots, 0.1, 0)
	add_beam(8, 4.5+adder, num_shots, 0.1, 0)
	add_beam(38, 5.4+adder, 13, 0.1, 0)
	add_beam(38, 6.9+adder, 15, 0.1, 0)

func add_foruth():
	#247
	#const adder = 247
	const adder = 247
	add_slit(1.8+adder,0,true)
	add_rain(0,2.4+adder,60, 0.4,false)
	add_rain(3,2.5+adder,60, 0.4,true)
	add_rain(6,2.6+adder,40, 0.4,false)
	add_rain(9,2.7+adder,60, 0.4,true)
	add_rain(0,2.45+adder,60, 0.4,false)
	add_rain(1,2.55+adder,60, 0.4,true)
	add_rain(2,2.65+adder,60, 0.4,false)
	add_rain(3,2.75+adder,40, 0.4,true)
	
	add_beam(45, 6+adder, 11, 1.08, 0)
	add_beam(15, 6.74+adder, 11, 1.08, 0)
	
	add_beam(28, 10+adder, 67, 0.3, 4)
	add_beam(26, 10.1+adder, 67, 0.3, 4)
	add_beam(24, 10.2+adder, 67, 0.3, 4)
	add_beam(23, 10.3+adder, 67, 0.3, 4)
	add_beam(22, 11.5+adder, 35, 0.3, 4)
	add_beam(21, 12+adder, 33, 0.3, 4)
	add_beam(20, 12.5+adder, 32, 0.3, 4)
	add_beam(19, 13+adder, 30, 0.3, 4)
	add_beam(18, 13.5+adder, 29, 0.3, 4)
	add_beam(17, 14+adder, 27, 0.3, 4)
	add_beam(16, 14.5+adder, 26, 0.3, 4)
	add_beam(15, 15+adder, 23, 0.3, 4)
	add_beam(14, 15.5+adder, 21, 0.3, 4)
	#Tranistion to top
	add_beam(4, 17.5+adder, 40, 0.3, 4)
	add_beam(6, 17.6+adder, 40, 0.3, 4)
	add_beam(7, 17.7+adder, 40, 0.3, 4)
	add_beam(8, 17.8+adder, 40, 0.3, 4)
	
	add_beam(9, 21+adder, 27, 0.3, 4)
	add_beam(10, 21.5+adder, 25, 0.3, 4)
	add_beam(11, 22+adder, 23, 0.3, 4)
	add_beam(12, 22.5+adder, 22, 0.3, 4)
	add_beam(13, 23+adder, 20, 0.3, 4)
	add_beam(14, 23.5+adder, 18, 0.3, 4)
	add_beam(15, 24+adder, 17, 0.3, 4)
	add_beam(16, 24.5+adder, 15, 0.3, 4)
	add_beam(17, 25+adder, 12, 0.3, 4)
	
func add_end():
	#278
	const adder = 278
	add_repeaters(0,1+adder, 6, 0.05)
	add_repeaters(15,1.25+adder, 6, 0.05)
	add_repeaters(30,1.5+adder, 6, 0.05)
	add_repeaters(45,1.75+adder, 6, 0.05)
	
	add_repeaters(0,2.8+adder, 6, 0.05)
	add_repeaters(15,3.05+adder, 6, 0.05)
	add_repeaters(30,3.3+adder, 6, 0.05)
	add_repeaters(45,3.55+adder, 6, 0.05)

	add_quad_simult(0,4.7+adder,2,0.4,1)
	add_quad_simult(45,5.4+adder,2,0.4,1)
	add_quad_simult(0,6.7+adder,2,0.4,1)
	
	add_stright(0,8.2+adder,10,0.4,0)
	add_stright(3,8.2+adder,10,0.4,0)
	add_stright(6,8.2+adder,5,0.4,0)
	add_stright(9,8.2+adder,5,0.4,0)
	
	add_stright(0,10.2+adder,10,0.4,1)
	add_stright(3,10.2+adder,10,0.4,1)
	add_stright(6,10.2+adder,10,0.4,1)
	add_stright(9,10.2+adder,10,0.4,1)
	
	#Hem in player
	#Left
	add_beam(47, 12+adder, 67, 0.3, 3)
	add_beam(49, 12.1+adder, 67, 0.3, 3)
	add_beam(51, 12.2+adder, 67, 0.3, 3)
	add_beam(52, 12.3+adder, 67, 0.3, 3)
	add_beam(53, 12.4+adder, 67, 0.3, 3)
	add_beam(54, 12.5+adder, 67, 0.3, 3)
	add_beam(55, 12.6+adder, 67, 0.3, 3)
	
	#Right
	add_beam(13, 13.1+adder, 67, 0.3, 3)
	add_beam(11, 13.2+adder, 67, 0.3, 3)
	add_beam(9, 13.3+ adder, 67, 0.3, 3)
	add_beam(8, 13.4+adder, 67, 0.3, 3)
	add_beam(7, 13.5+adder, 67, 0.3, 3)
	add_beam(5, 13.6+adder, 67, 0.3, 3)
	add_beam(4, 13.7+adder, 67, 0.3, 3)
	
	#Bottom
	add_beam(28, 13.8+adder, 67, 0.3, 4)
	add_beam(26, 13.9+adder, 67, 0.3, 4)
	add_beam(24, 14+adder, 67, 0.3, 4)
	add_beam(23, 14.1+adder, 67, 0.3, 4)
	add_beam(22, 14.2+adder, 67, 0.3, 4)
	add_beam(21, 14.3+adder, 67, 0.3, 4)
	add_beam(20, 14.4+adder, 67, 0.3, 4)
	
	#Top
	add_beam(4, 14.6+adder, 67, 0.3, 4)
	add_beam(6, 14.7+adder, 67, 0.3, 4)
	add_beam(7, 14.8+adder, 67, 0.3, 4)
	add_beam(8, 14.9+adder, 67, 0.3, 4)
	add_beam(9, 15+adder, 67, 0.3, 4)
	add_beam(10, 15.1+adder, 67, 0.3, 4)
	add_beam(11, 15.2+adder, 67, 0.3, 4)

	add_doot_doot(16+adder,60,0.25)
	add_circle(30,16+adder,100,0.1,1,true)
	
func set_master_list():
	#Intro
	add_intro()
	add_first()
	add_second()
	add_break_one()
	add_third()
	add_third_pt2()
	add_foruth()
	add_end()
	master_fire_list.sort_custom(_compare_fire_items)

# Custom comparison function
func _compare_fire_items(item1: FireItem, item2: FireItem) -> int:
	if item1.time_to_fire < item2.time_to_fire:
		return true
	return false
