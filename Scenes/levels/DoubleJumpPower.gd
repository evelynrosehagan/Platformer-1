extends Area2D




func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_jump(1)
		queue_free()
