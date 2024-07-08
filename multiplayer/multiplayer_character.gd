extends CharacterBody2D

signal basic_attack
var speed = 300.0
var can_attack : bool
var can_dash : bool
var player : bool
var player_name : String
var dash_speed = 900
var dash_duration = 0.1
var score : int
var direction = 1

@onready var animated_sprite = %AnimationPlayer

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)


@onready var dash = $Dash

func _ready():
	can_attack = true
	can_dash = true
	player = true
	player_name = "Savay"
	score = 0
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
	
func _apply_animations(delta):
	if velocity.x == 0 and velocity.y == 0:
		play_idle_animation()
	else:
		play_walk_animation()

func _apply_movement_from_input(delta):
	direction = %InputSynchronizer.input_direction
	var speed_calc = dash_speed if dash.is_dashing() else speed
	velocity = direction * speed_calc
	move_and_slide()

func _physics_process(delta):
	#if multiplayer.is_server():
		_apply_movement_from_input(delta)
		
	#if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
		_apply_animations(delta)
	
func play_idle_animation():
	animated_sprite.play("Idle")
	
func play_walk_animation():
	animated_sprite.play("Walk")

func _on_attack_cd_timeout():
	can_attack = true

func _on_stun_cd_timeout():
	speed = 300

func _on_dash_cd_timeout():
	can_dash = true
