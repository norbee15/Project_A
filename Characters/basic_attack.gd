extends Area2D

var speed : int = 400
var direction : Vector2
var attacker : String

	
func _process(delta):
	position += speed * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if "player" in body:
		if body.name != attacker:
			body.speed = 0
			body.get_node("StunCD").start()
			queue_free()

	if body.name == "Rock":
		queue_free()
