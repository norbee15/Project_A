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

	var x = randf_range(rndarea.position.x-30, rndarea.position.x+30)
	var y = randf_range(rndarea.position.y-30, rndarea.position.y+30)
	var spawn = coin.instantiate()
	spawn.position.x = x
	spawn.position.y = y
	
	spawn.set_script(scriptcoin)
	get_parent().add_child(spawn)
