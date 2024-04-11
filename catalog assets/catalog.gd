extends Node2D

signal catalog_cards_updated(cards)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cards_parent_spawned_cards(cards):
	emit_signal("catalog_cards_updated", cards)
