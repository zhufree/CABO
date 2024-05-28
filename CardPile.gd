extends Node2D

var cards = []
var card_node = []
@export var type = Type.DECK
enum Type {
	DECK, DISCARD
}
var card_scene = preload("res://Card.tscn")

func _init():
	if type == Type.DECK:
		cards = Cards.init_cards.duplicate()
		cards.shuffle()
		for card in cards:
			var new_card_node = card_scene.instantiate()
			new_card_node.init(card, cards.find(card))
			card_node.append(new_card_node)
			add_child(new_card_node)
	else:
		pass

func draw_cards(count=1):
	var return_cards = []
	for i in range(count):
		remove_child(card_node.pop_back())
		return_cards.append(cards.pop_front())
	return return_cards

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
