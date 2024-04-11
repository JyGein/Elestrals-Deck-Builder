extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_catalog_catalog_cards_updated(cards):
	for card_node in cards:
		card_node.card_inspected.connect(_on_base_card_card_inspected)
	

func _on_base_card_card_inspected(image):
	var instancedCard = preload("res://base_card.tscn")
	var card = instancedCard.instantiate()
	add_child(card)
	var CARD_WIDTH = 412
	var scale_factor = CARD_WIDTH/card.texture.get_size().x
	card.scale = Vector2(scale_factor, scale_factor)
	@warning_ignore("integer_division")
	card.position = Vector2(1152/2 - scale_factor*card.texture.get_size().x/2, 648/2 - scale_factor*card.texture.get_size().y/2)
	card.z_index = 10
	card.texture = image
	await card.card_inspected
	card.queue_free()
