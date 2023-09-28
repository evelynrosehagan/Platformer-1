extends Node2D

var children

func _ready():
	children = get_children()

func _on_player_player_death(player):
	for child in children:
		child.on_player_death(player)
	
