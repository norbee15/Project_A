extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Fire")

func _on_area_2d_body_entered(body):
	if "player" in body:
		print("mmm szóóósz mmmm")
