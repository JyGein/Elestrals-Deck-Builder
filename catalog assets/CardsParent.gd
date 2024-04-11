extends Node2D

var cards = []
var count = 0
var CATALOG_WIDTH
var SPACING
var CARD_WIDTH
var CARD_HEIGHT
# Called when the node enters the scene tree for the first time.
func _ready():
	var instancedCard = preload("res://base_card.tscn")
	var dir = DirAccess.open("res://Cards/")
	CATALOG_WIDTH = $"../Bg".texture.get_size().x
	SPACING = CATALOG_WIDTH*0.01
	CARD_WIDTH = (CATALOG_WIDTH*0.8-3*SPACING)/4
	CARD_HEIGHT = (CARD_WIDTH*1125)/825
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name[-1] == "g":
				cards.append(instancedCard.instantiate())
				var card = cards[-1]
				add_child(card)
				card.texture = load("res://Cards/{0}".format([file_name]))
				var scale_factor = CARD_WIDTH/card.texture.get_size().x
				card.scale = Vector2(scale_factor, scale_factor)
				card.position = Vector2((CATALOG_WIDTH*0.1)+(count%4)*(CARD_WIDTH+SPACING), (CATALOG_WIDTH*0.1)+(count/4)*(CARD_HEIGHT+SPACING)) #warning-ignore:integer_division
				count+=1
			file_name = dir.get_next()

var last_drag_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(position.y)
	print(-((count/4)*(CARD_HEIGHT+SPACING)-SPACING))
	if position.y > 0 && Time.get_ticks_msec() > (last_drag_time+100):
		position.y-=(position.y+10)*(1.0/10.0)
	if position.y < -((count/4)*(CARD_HEIGHT+SPACING)-SPACING) && Time.get_ticks_msec() > (last_drag_time+100):
		position.y-=(position.y+((count/4)*(CARD_HEIGHT+SPACING)-SPACING)-10)*(1.0/10.0)

func _on_texture_button_gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			position.y += event.relative.y
			last_drag_time = Time.get_ticks_msec()
