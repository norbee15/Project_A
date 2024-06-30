extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

# Referencia az IP cím beviteli ablakához és a LineEdit-hez
@onready var ip_dialog = $VBoxContainer/IPDialog
@onready var ip_line_edit = $VBoxContainer/IPDialog/VBoxContainer/IPLineEdit
@onready var port_line_edit = $VBoxContainer/IPDialog/VBoxContainer/PortLineEdit
@onready var host_button : Button = $VBoxContainer/Host
@onready var join_button : Button = $VBoxContainer/Join
@onready var ingameexit_button : Button = $inGameExit
@onready var name_input_panel : Control = $NameInputPanel
@onready var name_input_field : LineEdit = $NameInputPanel/VBoxContainer/NameInputField
@onready var ok_button : Button = $NameInputPanel/VBoxContainer/OKButton


func _ready():
	# Csatlakoztatjuk a dialog gombokhoz tartozó signalokat
	ip_dialog.dialog_hide_on_ok = false # Ensure dialog doesn't hide automatically on OK
	ip_dialog.get_ok_button().connect("pressed", Callable(self, "_on_ip_dialog_confirmed"))
	ip_dialog.connect("popup_hide", Callable(self, "_on_ip_dialog_closed"))
	name_input_field.connect("text_entered", Callable(self, "_on_name_entered"))
	ok_button.connect("pressed", Callable(self, "_on_ok_button_pressed"))

	# Elrejtjük az input panelt kezdetben
	
	hide_name_input()
	ingameexit_button.hide()

func _process(delta):
	pass

func _on_host_pressed():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null

	peer.create_server(775)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	show_name_input()  # Kérjük be a nevet
	host_button.hide()
	join_button.hide()
	ingameexit_button.show()

	print("Hosting server on port 775")

func _on_join_pressed():
	# Megjelenítjük az IP cím beviteli ablakot
	ip_dialog.popup_centered()
	print("IP Address:", ip_line_edit.text)
	print("Port:", port_line_edit.text.to_int())

func _on_ip_dialog_confirmed():
	var ip_address = ip_line_edit.text
	var ip_port = port_line_edit.text.to_int()
	if ip_address == "":
		print("No IP address entered")
		return


	print("IP Address:", ip_address)
	print("Port:", str(ip_port))

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
	show_name_input()  # Kérjük be a nevet

func _on_connection_failed():
	print("Failed to connect to server")

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	var label = Label.new()
	label.text = player.name
	player.add_child(label)
	call_deferred("add_child", player)
	print("Added player with ID:", id)

func _remove_player(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()
	print("Removed player with ID:", id)

func _on_name_entered(name):
	_add_player(multiplayer.get_unique_id()) # Használjuk a multiplayer.get_unique_id() metódust
	hide_name_input()

func _on_ok_button_pressed():
	var name = name_input_field.text
	if name.strip_edges() == "":
		print("No name entered")
		return
	_on_name_entered(name)

func show_name_input():
	name_input_panel.visible = true
	name_input_field.text = ""
	name_input_field.grab_focus()

func hide_name_input():
	name_input_panel.visible = false
	name_input_field.text = ""
