extends Area2D

@export var checkpoint_active : bool = false
@onready var _animated_sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		deactivate_other_nodes()
		checkpoint_active = true
		_animated_sprite.play("Activate")

func deactivate_checkpoint():
	checkpoint_active = false
	
	_animated_sprite.play("Deactivated")

func deactivate_other_nodes():
	var checkpoints = get_parent().get_children()
	for x in checkpoints:
		x.deactivate_checkpoint()
	

func on_player_death(player):
	if checkpoint_active:
		player.position = global_position
