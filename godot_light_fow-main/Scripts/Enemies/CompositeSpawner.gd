extends Node


func set_spawner(player: Player, holder):
	for point in self.get_children():
		point.set_spawner(player, holder)
		point.start()
		
func start():
	for point in self.get_children():
		point.start()
