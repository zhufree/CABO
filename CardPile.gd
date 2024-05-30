extends Control

var cards = []
var card_node = []
@export var type = Type.DECK
enum Type {
	DECK, DISCARD
}
var card_scene = preload("res://Card.tscn")
@onready var state_manager = $"../../../../../../GameStateManager"

signal draw_card(card)

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == Type.DECK:
		cards = Cards.init_cards.duplicate()
		cards.shuffle()
		for card in cards:
			var new_card_node = card_scene.instantiate()
			new_card_node.init(card, cards.find(card), Card.CardType.PILE)
			card_node.append(new_card_node)
			add_child(new_card_node)
	else:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func draw_cards(count=1):
	var return_cards = []
	for i in range(count):
		remove_child(card_node.pop_back())
		return_cards.append(cards.pop_front())
	return return_cards

func draw_cards_in_turn():
	var one_card = draw_cards()
	emit_signal("draw_card", one_card[0])

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if state_manager.current_state == state_manager.GameState.DRAW:
			draw_cards_in_turn()
