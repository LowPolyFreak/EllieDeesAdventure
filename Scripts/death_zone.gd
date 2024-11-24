extends Area3D

func _on_body_entered(body):
	if body is Player and !Globals.player_dead:
		body.death()
