extends Area2D



var coin = preload("res://Scenes/coin.tscn")
var scriptcoin = preload("res://Scenes/coin.gd")
var spawnareas = []
func _ready():
	get_all()
	
func _on_body_entered(body):
	body.score += 1
	print("Player X: ",body.position.x, "Y: ", body.position.y)
	spawn_New_Coin()
	queue_free()
	


func get_all():
	for child in get_tree().get_nodes_in_group("spawnareas"):
		spawnareas.append(child)
		
func spawn_New_Coin():
	var rndarea = spawnareas.pick_random()
	print(rndarea)
	print("Area position: ", rndarea.position)
	rndarea = rndarea.shape.get_rect()
	var x = randf_range(rndarea.position.x, rndarea.end.x)
	var y = randf_range(rndarea.position.y, rndarea.end.y)
	var spawn = coin.instantiate()
	spawn.position.x = x
	spawn.position.y = y
	print("Spawn position: ", spawn.position)
	spawn.set_script(scriptcoin)
	get_parent().add_child(spawn)
