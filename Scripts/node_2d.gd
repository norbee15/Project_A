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

@onready var dash = $Dash

func _ready():
	can_attack = true
	can_dash = true
	player = true
	player_name = "Savay"
	score = 0

func _physics_process(delta):
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dash.start_dash(dash_duration)
		can_dash = false
		$DashCD.start()
	
	var speed_calc = dash_speed if dash.is_dashing() else speed
	velocity = direction * speed_calc
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_attack:
		var aim = get_global_mouse_position() - position
		basic_attack.emit(position, aim, name)
		can_attack = false
		$AttackCD.start()
		
	move_and_slide()
	
	if velocity.length() > 0.0:
		play_walk_animation()
	else:
		play_idle_animation()

func play_idle_animation():
	%AnimationPlayer.play("Idle")
	
func play_walk_animation():
	%AnimationPlayer.play("Walk")

func _on_attack_cd_timeout():
	can_attack = true

func _on_stun_cd_timeout():
	speed = 300

func _on_dash_cd_timeout():
	can_dash = true
