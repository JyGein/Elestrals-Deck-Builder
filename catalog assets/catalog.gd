extends Node2D

signal catalog_cards_updated(cards)
signal loaded_card
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func load_cards(cards):
	await $"Manual Drag Button/Cards Parent".load_cards(cards)

func _on_cards_parent_spawned_cards(cards):
	emit_signal("catalog_cards_updated", cards)

func _on_cards_parent_loaded_card():
	emit_signal("loaded_card")
