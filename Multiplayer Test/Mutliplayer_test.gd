extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_host_pressed():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close_connection()
		multiplayer.multiplayer_peer = null

	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	_add_player()

	print("Hosting server on port 135")

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	print("Added player with ID:", id)

func _remove_player(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()
	print("Removed player with ID:", id)

func _on_join_pressed():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close_connection()
		multiplayer.multiplayer_peer = null

	var result = peer.create_client("82.150.39.25", 135)
	if result == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(_on_connected_to_server)
		multiplayer.connection_failed.connect(_on_connection_failed)

		print("Attempting to join server at 82.150.39.25:135")
	else:
		print("Failed to create client:", result)

func _on_connected_to_server():
	print("Successfully connected to server")
	_add_player(get_tree().get_network_unique_id())

func _on_connection_failed():
	print("Failed to connect to server")
