extends Area2D

var coin = preload("res://Scenes/flipping_coin.tscn")
var coinsript = preload("res://Scenes/flipping_coin.gd")
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
	var spawn = coin.instantiate()
	spawn.position.x = x
	spawn.position.y = y
	
	spawn.set_script(coinsript)
	get_parent().call_deferred("add_child",spawn)
	queue_free()

	
