extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

# Referencia az IP cím beviteli ablakához és a LineEdit-hez
@onready var ip_dialog = $VBoxContainer/IPDialog
@onready var ip_line_edit = $VBoxContainer/IPDialog/VBoxContainer/PortLineEdit
@onready var port_line_edit = $VBoxContainer/IPDialog/VBoxContainer/IPLineEdit
@onready var host_button : Button = $VBoxContainer/Host
@onready var join_button : Button = $VBoxContainer/Join
@onready var ingameexit_button : Button = $inGameExit

func _ready():
	# Csatlakoztatjuk a dialog gombokhoz tartozó signalokat
	ip_dialog.dialog_hide_on_ok = false # Ensure dialog doesn't hide automatically on OK
	ip_dialog.get_ok_button().connect("pressed", Callable(self, "_on_ip_dialog_confirmed"))
	ip_dialog.connect("hide", Callable(self, "_on_ip_dialog_closed"))

func _process(delta):
	pass

func _on_host_pressed():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null

	peer.create_server(775)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	_add_player()
	host_button.hide()
	join_button.hide()
	ingameexit_button.show()

	print("Hosting server on port 775")

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
	# Megjelenítjük az IP cím beviteli ablakot
	ip_dialog.popup_centered()

func _on_ip_dialog_confirmed():
	var ip_address = ip_line_edit.text
	var ip_port = port_line_edit.text.to_int()
	if ip_address == "":
		print("No IP address entered")
		return

	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null

	var result = peer.create_client(ip_address, ip_port)
	if result == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(_on_connected_to_server)
		multiplayer.connection_failed.connect(_on_connection_failed)

		print("Attempting to join server at " + ip_address + ":" + str(ip_port))
	else:
		print("Failed to create client:", result)

func _on_ip_dialog_closed():
	ip_line_edit.text = ""
	port_line_edit.text = ""

func _on_connected_to_server():
	print("Successfully connected to server")
	#_add_player(get_tree().get_network_unique_id())
	host_button.visible = false
	join_button.visible = false
	ingameexit_button.show()

func _on_connection_failed():
	print("Failed to connect to server")


func _on_button_pressed():
	get_tree().quit()
