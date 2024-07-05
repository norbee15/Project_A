extends Control

@onready var start = $VBoxContainer/Start as Button
@onready var multi = $VBoxContainer/Multiplayer as Button
@onready var settings = $VBoxContainer/Settings as Button
@onready var exit = $VBoxContainer/ExitGame as Button

@export var gamescene = preload("res://Scenes/game.tscn")

func _ready():
	start.button_down.connect(on_start_pressed)
	multi.button_down.connect(on_multi_pressed)
	settings.button_down.connect(on_settings_pressed)
	exit.button_down.connect(on_exit_pressed)

func on_start_pressed():
	get_tree().change_scene_to_packed(gamescene)

func on_multi_pressed():
	# Add your functionality for the multiplayer button here
	pass

func on_settings_pressed():
	# Add your functionality for the settings button here
	pass

func on_exit_pressed():
	get_tree().quit()
