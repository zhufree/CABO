extends BoxContainer

signal finish_draw(player_number)
signal finish_replace_card
signal finish_peek_card
@export var player_type = PlayerType.HUMAN
enum PlayerType {
	HUMAN, AI
}
var player_number = 0
var player_card_numbers = []
var player_card_nodes = []
var card_scene = preload("res://Card.tscn")
@onready var state_manager = $"../../../../../GameStateManager"

func restart():
	player_card_numbers = []
	player_card_nodes = []
	for child in get_children():
		child.queue_free()

func is_player():
	return player_type == PlayerType.HUMAN

func draw_default_cards(cards):
	for index in cards.size():
		var new_card = card_scene.instantiate()
		if is_player():
			new_card.init(cards[index], index, Card.CardType.PLAYER)
		else:
			new_card.init(cards[index], index, Card.CardType.AI)
		new_card.connect("drop_card", Callable(self, "_on_player_card_drop"))
		new_card.connect("finish_peek_card", Callable(self, "_on_player_finish_peek_card"))
		player_card_nodes.append(new_card)
		player_card_numbers.append(cards[index])
		add_child(new_card)
		new_card.refresh_display()
		if is_player():
			await get_tree().create_timer(0.5).timeout
	if (is_player()):
		state_manager.transition_to(state_manager.GameState.CHECK)


func _on_player_card_drop(index, is_replace = false, replace_card_number = -1):
	# replace the old card
	if is_replace:
		player_card_numbers[index] = replace_card_number
		var new_card_node = card_scene.instantiate()
		new_card_node.init(replace_card_number, index)
		player_card_nodes[index] = new_card_node
		if index == 0: # the last card
			add_child(player_card_nodes[index])
			move_child(player_card_nodes[index], 0)
		else:
			player_card_nodes[index-1].add_sibling(player_card_nodes[index])
		player_card_nodes[index].refresh_display()
		player_card_nodes[index].reveal_card()
		emit_signal("finish_replace_card")


func _on_player_finish_peek_card():
	emit_signal("finish_peek_card")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
