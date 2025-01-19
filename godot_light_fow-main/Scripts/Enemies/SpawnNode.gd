extends Node
const Grunt = preload("res://scenes/Enemies/Grunt.tscn")
const BurstSpitter = preload("res://scenes/Enemies/BurstSpitter.tscn")


#0
@export var spawn_index = 0
@export var will_respawn: bool = false
@export var respawn_timer: float = 0
var player_ref: Player
var inital_spawn: bool = true
var timer: float = respawn_timer
var enemy_holder
var spawned_enemy

func set_enemy(enemy):
	enemy.set_player(player_ref)
	enemy.global_position = self.global_position
	spawned_enemy = enemy

func spawn():
	var enemy
	match spawn_index:
		0:
			enemy = Grunt.instantiate()
			enemy.health = 4
			enemy.speed = 100
		1:
			enemy = BurstSpitter.instantiate()
			enemy.fire_cooldown = 3
			enemy.num_bullets = 1
			enemy.spread_array = []
			enemy.spread_angle = 0
		2:
			enemy = BurstSpitter.instantiate()
		3:
			enemy = BurstSpitter.instantiate()
			enemy.fire_cooldown = 4
			enemy.spread_array = []
			enemy.num_bullets = 9
			enemy.spread_angle = PI / 6
		4:
			enemy = Grunt.instantiate()
			enemy.health = 10
			enemy.speed = 60
		_:
			enemy = Grunt.instantiate()
	set_enemy(enemy)
	enemy_holder.add_child(enemy)

func set_spawner(player: Player, holder):
	player_ref = player
	enemy_holder = holder

func _ready():
	pass # Replace with function body.

func start():
	if inital_spawn:
		inital_spawn = false
		timer = respawn_timer
		spawn()
	elif not will_respawn:
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#We know it has started
	if not inital_spawn and will_respawn:
		if timer <= 0 and spawned_enemy == null:
			timer = respawn_timer
			spawn()
		elif spawned_enemy == null:
			timer -= delta
