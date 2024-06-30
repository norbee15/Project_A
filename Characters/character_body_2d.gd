extends CharacterBody2D

func _enter_tree():
	set_multiplayer_authority(name.to_int())

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if (is_multiplayer_authority()):
		velocity = Input.get_vector("ui_left","ui_right", "ui_up", "ui_down") * 1000
	move_and_slide()
	
	
