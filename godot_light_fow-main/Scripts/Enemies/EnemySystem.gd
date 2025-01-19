extends Node

var player_ref : Player
@onready var enemy_holder = $EnemyHolder

func set_player(player: Player):
	player_ref = player
	for point in self.get_children():
		if point != enemy_holder:
			point.set_spawner(player, enemy_holder)
			point.start()
