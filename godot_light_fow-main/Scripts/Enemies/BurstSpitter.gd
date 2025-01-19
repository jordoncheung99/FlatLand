extends GenericEnemy

#Should have I made a generic enemy with it's own los and nav so that I could reuse the code
#Yes but copy and paste is working YEET
const GenericEnemy = preload("res://Scripts/Enemies/GenericEnemy.gd")
const Spitter_Bullet = preload("res://scenes/Enemies/SpitterBullet.tscn")

@onready var los = $LineOfSight
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var spitter_range = $SpittingRange
@onready var gun_helper = $GunHelper
@onready var hit_player = $HitPlayer

@export var fire_cooldown = 5
@export var num_bullets = 6
@export var spread_array = [.025, .05, -.05, -.025]
@export var spread_angle = 0.05

var target_location: Vector2 = Vector2.ZERO
const minimum_distance = 150
var scampering: bool = false

#scamper system
const angles_to_check = [ PI/2, (3*PI)/2, PI, -PI/2, (-3*PI)/2 ]
var index: int = 0
var distance: float = 0
var path_towards_player: bool = true
var scamper_vector: Vector2 = Vector2.ZERO

func _ready():
	gun_helper.spawn_bullet.connect(_spawn_bullet)
	gun_helper.fire_cooldown = fire_cooldown
	gun_helper.num_bullets = num_bullets
	gun_helper.spread_array = spread_array
	gun_helper.spread_angle = spread_angle

func _physics_process(delta):
	if player:
		if gun_helper.on_idle():
			if check_ray_in_range(los):
				gun_helper.wakeup()
		else:
			try_to_attack(delta)

func check_ray_in_range(ray: RayCast2D) -> bool:
	ray.look_at(player.global_position)
	var collider = ray.get_collider()
	if collider and collider == player:
		return true
	return false

func try_to_attack(delta: float):
	if gun_helper.on_ready():
		scampering = false
		if check_ray_in_range(spitter_range):
			gun_helper.set_fire()
			reset_scamper()
	
	#stand still and fire
	if gun_helper.on_firing():
		#need to do this once per physic update so the path is calculated
		pick_scamper_point_2()
		return

	move()

func hit(dmg: int):
	damage(dmg)
	var splat = hit_splat_scene.instantiate()
	splat.set_splat(self.global_position, player.global_position.angle_to_point(self.global_position))
	self.add_sibling(splat)
	hit_player.play(0.6)

func move():
	
	#Shuffle away like a scamp
	if scampering:
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
	
func get_scamper_vector(_index: int) -> Vector2:
	var towards_player_vector = (global_position - player.global_position).normalized()
	towards_player_vector.rotated(angles_to_check[_index])
	const look_distance = 200
	return global_position + towards_player_vector * look_distance

func pick_scamper_point_2():
	#TODO optmize
	if index == angles_to_check.size():
		if get_path_distance() > distance:
			scamper_vector = nav.get_final_position()
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
		
func _spawn_bullet(angle: float):
	var bullet = Spitter_Bullet.instantiate()
	var angle_to_player = global_position.direction_to(player.global_position).angle()
	angle_to_player += angle
	bullet.spawn(global_position, angle_to_player)
	self.add_sibling(bullet)
