extends Area2D

var spawnareas = []

func _ready():
	get_all()

func _on_body_entered(body):
	body.score += 1
	spawn_New_Coin()

func get_all():
	for child in get_tree().get_nodes_in_group("spawnareas"):
		spawnareas.append(child)

func spawn_New_Coin():
	var rndarea = spawnareas.pick_random()
	var x = randf_range(rndarea.position.x-30, rndarea.position.x+30)
	var y = randf_range(rndarea.position.y-30, rndarea.position.y+30)
	self.position.x = x
	self.position.y = y
