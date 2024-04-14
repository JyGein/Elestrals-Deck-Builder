extends Node2D

signal spawned_cards(cards)
var card_objects = []
var CATALOG_WIDTH
var SPACING
var CARD_WIDTH
var CARD_HEIGHT
@export var CATALOG_HEIGHT: int
# Called when the node enters the scene tree for the first time.
func _ready():
	CATALOG_WIDTH = $"../Bg".texture.get_size().x
	SPACING = CATALOG_WIDTH*0.01
	CARD_WIDTH = (CATALOG_WIDTH*0.8-3*SPACING)/4
	CARD_HEIGHT = (CARD_WIDTH*1125)/825
	CATALOG_HEIGHT = 0 - SPACING

func load_cards(card_data):
	for child in get_children():
		child.queue_free()
	var instancedCard = preload("res://base_card.tscn")
	var count = 0
	var regex = RegEx.new()
	regex.compile(r".+\.([A-z]{3,4})")
	for card_name in card_data:
		if card_data[card_name]["Type"] != "Template":
			for Art in card_data[card_name]["Arts"]:
				var image_type = regex.search(Art[1]).get_string(1)
				var image_path = "user://Cards/{0} {1} {2}.{3}".format([Art[2], card_name, Art[0], image_type])
				var card = instancedCard.instantiate()
				card_objects.append(card)
				add_child(card)
				var card_image = Image.load_from_file(image_path)
				card.texture = ImageTexture.create_from_image(card_image)
				if card.texture:
					var scale_factor = CARD_WIDTH/card.texture.get_size().x
					card.scale = Vector2(scale_factor, scale_factor)
					@warning_ignore("integer_division")
					card.position = Vector2((CATALOG_WIDTH*0.1)+(count%4)*(CARD_WIDTH+SPACING), (CATALOG_WIDTH*0.1)+(count/4)*(CARD_HEIGHT+SPACING)) #warning-ignore:integer_division
					card.card_data = card_data[card_name]
					card.card_name = card_name
				count+=1
	emit_signal("spawned_cards", card_objects)
	@warning_ignore("integer_division")
	CATALOG_HEIGHT = ((count/4)*(CARD_HEIGHT+SPACING)-SPACING)

var last_drag_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > 0 && Time.get_ticks_msec() > (last_drag_time+100):
		position.y-=(position.y+10)*(1.0/10.0)
	if position.y < -CATALOG_HEIGHT && Time.get_ticks_msec() > (last_drag_time+100):
		position.y-=(position.y+CATALOG_HEIGHT-10)*(1.0/10.0)

func _on_manual_drag_button_gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			position.y += event.relative.y
			last_drag_time = Time.get_ticks_msec()


func _on_slider_slider_sliding(percent):
	position.y = -percent*CATALOG_HEIGHT
