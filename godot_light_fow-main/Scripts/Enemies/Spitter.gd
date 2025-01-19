extends GenericEnemy

#Should have I made a generic enemy with it's own los and nav so that I could reuse the code
#Yes but copy and paste is working YEET
const GenericEnemy = preload("res://Scripts/Enemies/GenericEnemy.gd")
#const SpitterBullet = preload("res://scenes/Enemies/SpitterBullet.tscn")
@onready var los = $LineOfSight
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var spitter_range = $SpittingRange
var player_spotted: bool = false

#firing system
var max_windup: float = 0.5
var current_windup: float  = 0
#var fire_cooldown: float = 10
var fire_cooldown: float = 3
var current_fire_cooldown: float = 0
var firing: bool = false
var target_location: Vector2 = Vector2.ZERO
const minimum_distance = 150
var scampering: bool = false

#scamper system
const angles_to_check = [ PI/2, (3*PI)/2, PI, -PI/2, (-3*PI)/2 ]
var index: int = 0
var distance: float = 0
var path_towards_player: bool = true
var scamper_vector: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if player:
		if player_spotted:
			try_to_attack(delta)
		else:
			player_spotted = check_ray_in_range(los)

func check_ray_in_range(ray: RayCast2D) -> bool:
	ray.look_at(player.global_position)
	var collider = ray.get_collider()
	if collider and collider == player:
		return true
	return false

func try_to_attack(delta: float):
	if current_fire_cooldown > 0:
		current_fire_cooldown -= delta
		
	#stand still and fire
	if current_windup > 0:
		pick_scamper_point_2()
		current_windup -= delta
		return
	elif firing:
		var bullet = SpitterBullet.instantiate()
		#bullet.spawn(self.global_position, $SpittingRange.rotation, lighting_reference)
		self.add_sibling(bullet)
		current_fire_cooldown = fire_cooldown
		firing = false
		return
	
	if check_ray_in_range(spitter_range) and current_fire_cooldown <= 0:
		reset_scamper()
		current_windup = max_windup
		firing = true
		return
	
	move()


func hit(dmg: int):
	damage(dmg)

func move():
	
	#Shuffle away like a scamp
	if current_fire_cooldown > 0 and scampering:
		if nav.is_target_reached():
			scampering = false
	#Attempt to stay at maximum range away from player
	elif check_ray_in_range(spitter_range) and self.global_position.distance_to(player.global_position) < minimum_distance:
		return
	else:
		nav.target_position = player.global_position
		
	var direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func reset_scamper():
	index = 0
	distance = 0
	path_towards_player = true
	nav.target_position = get_scamper_vector(index)
	index += 1
	scamper_vector = Vector2.ZERO
	scampering = true
	
func get_scamper_vector(index: int) -> Vector2:
	var towards_player_vector = (global_position - player.global_position).normalized()
	towards_player_vector.rotated(angles_to_check[index])
	const look_distance = 200
	return global_position + towards_player_vector * look_distance

func pick_scamper_point_2():
	#TODO optmize
	if index == angles_to_check.size():
		if get_path_distance() > distance:
			scamper_vector = nav.get_final_position()
			#TODO check if towards player
		return
	elif index > angles_to_check.size():
		return
	
	if get_path_distance() > distance:
		scamper_vector = nav.get_final_position()
		#TODO check if towards player
	nav.target_position = get_scamper_vector(index)
	index += 1

func get_path_distance() -> float:
	var array = nav.get_current_navigation_path()
	
	if (array.size() == 0):
		return 0
		
	var start: Vector2 = global_position
	var end = array[0]
	var total_distance: float = 0
	total_distance += start.distance_to(end)
	for i in range(1,array.size()-1):
		start = array[i - 1]
		end = array[i]
		total_distance += start.distance_to(end)
	return total_distance
		
