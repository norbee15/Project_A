extends Node2D

@export var basic_attack_scene : PackedScene


func _on_char_1_basic_attack(pos, dir, attacker):
	var basic_attack = basic_attack_scene.instantiate()
	add_child(basic_attack)
	basic_attack.attacker = attacker
	basic_attack.position = pos
	basic_attack.direction = dir.normalized() 
	basic_attack.add_to_group("basic_attacks")
