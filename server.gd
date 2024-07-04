extends Node

var player = preload("res://Scenes/Character.tscn")
var otherplayer = preload("res://Scenes/Character.tscn")
var map = preload("res://Scenes/game.tscn")

var enemy_bullet = preload("res://Scenes/basic_attack.tscn")
var bullet = preload("res://Scenes/basic_attack.tscn")

func _ready():
	multiplayer.connect("connected_to_server", Callable(self, "_connected_to_server"))
	multiplayer.connect("server_disconnected", Callable(self, '_server_disconnected'))
	multiplayer.connect("connection_failed", Callable(self, "connection_failed"))

func join_server():
	var client = ENetMultiplayerPeer.new()
	var err = client.create_client("127.0.0.1", 4242)
	if err != OK:
		print("unable_to_connect")
		return
	multiplayer.multiplayer_peer = client

func connection_failed():
	get_node("/root/Lobby/join").disabled = false
	print("Connection failed")

func _server_disconnected():
	get_node("/root/Lobby").show()
	print("server disconnected")

func _connected_to_server():
	get_node("/root/Lobby").hide()
	print("Connected to server")
	var scene = map.instantiate()
	scene.name = "Map"
	get_tree().root.add_child(scene,true)

@rpc("any_peer") 
func instance_player(id, location):
	var p = player if get_tree().get_multiplayer().get_unique_id() == id else otherplayer
	var player_instance = instance_node(p , Nodes, location)
	player_instance.unique_id = str(id)
	if get_tree().get_multiplayer().get_unique_id() == id:
		for i in get_tree().get_multiplayer().get_peers():
			if i != 1:
				instance_player(i, location)

@rpc("any_peer") 
func instance_new_bullet(id, bullet_name, rot, pos):
	var b = bullet if get_tree().get_unique_id() == id else enemy_bullet
	var bullet_instance = instance_node(b, Nodes, pos)
	bullet_instance.player_rot = rot
	bullet_instance.name = bullet_name

@rpc("any_peer") 
func player_damaged(id, hp):
	var p = Nodes.get_node(str(id))
	if get_tree().get_unique_id() != id:
		p.hp = hp
	var prev_modulate = p.modulate
	p.modulate = Color(5,5,5,1)
	await get_tree().create_timer(0.1).timeout
	p.modulate = prev_modulate

@rpc("any_peer") 
func player_killed(id):
	var killed_player = Nodes.get_node(str(id))
	killed_player.get_node("shape").disabled = true
	killed_player.set_physics_process(false)
	killed_player.hide()
	if id == get_tree().get_unique_id():
		get_node("../Map/failed").show()
		await get_tree().create_timer(3).timeout
		get_node("../Map/failed").hide()
		rpc_id(1, "respawn_player", get_tree().get_unique_id())
	
@rpc("any_peer") 
func respawn_player(id, location):
	if Nodes.has_node(str(id)):
		var player = Nodes.get_node(str(id))
		player.global_position = location
		player.get_node("shape").disabled = false
		player.set_physics_process(true)
		player.hp = 100
		player.show()

@rpc("any_peer") 
func update_highest(kills):
	get_node("../Map").update_highest(kills)

@rpc("any_peer") 
func update_kills(kills):
	get_node("../Map").update_kills(kills)

@rpc("any_peer") 
func update_player_transform(id, position, rotation, velocity):
	if get_tree().get_multiplayer().get_unique_id() != id:
		Nodes.get_node(str(id)).update_transform(position, rotation, velocity)

@rpc("any_peer") 
func delete_obj(id):
	if Nodes.has_node(str(id)):
		Nodes.get_node(str(id)).queue_free()
		
@rpc("any_peer")
func instance_bullet(player_rot, player_pos):
	pass
	
@rpc("any_peer")
func update_transform(position, rotation, velocity):
	pass
	
@rpc("any_peer")
func destroy_bullet(bullet_name):
	pass

@rpc("any_peer")
func _player_disconnected(id):
	pass
	
func instance_node(scene_resource, parent, location):
	var scene_instance = scene_resource.instantiate()
	scene_instance.global_position = location
	parent.add_child(scene_instance)
	return scene_instance
