extends MultiplayerSynchronizer

var input_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	#input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_direction = Input.get_axis("move_left", "move_right")
	#input_direction2 = Input.get_

func _physics_process(delta):
	#input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_direction = Input.get_axis("move_left", "move_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
