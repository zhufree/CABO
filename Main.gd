class_name Game
extends Node2D

var player_card_numbers = []
var current_draw_card
var player_card_nodes = []
var card_scene = preload("res://Card.tscn")

var cardSelected
var mouseOnPlacement = false
@onready var state_manager = $GameStateManager
@onready var hand_card = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/HandCard
@onready var notice_label = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/NoticeLabel
@onready var card_tile = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/CardTile
@onready var player_card_container = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/PlayerCardContainer
@onready var operation_container = $HUD/OperationContainer
@onready var restart_button = $HUD/RestartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	operation_container.hide()
	card_tile.card_type = Card.CardType.TILE
	#card_tile.connect("draw_card", self, "_on_draw_card")

func restart():
	state_manager.transition_to(state_manager.GameState.INIT)
	Global.check_count = 0
	Global.game_round = 0
	player_card_numbers = []
	player_card_nodes = []
	operation_container.hide()
	# clear all children in player_card_container
	for child in player_card_container.get_children():
		child.queue_free()
	for child in hand_card.get_children():
		child.queue_free()
	_on_start_countdown_timeout()

func add_default_cards():
	for i in range(4):
		var new_card = card_scene.instantiate()
		var new_card_number = Global.cards.pick_random()
		Global.cards.erase(new_card_number) # remove the card from cards
		new_card.number = new_card_number
		new_card.index = i
		new_card.connect("drop_card", Callable(self, "_on_player_card_drop"))
		new_card.connect("peek_card", Callable(self, "_on_player_peek_card"))
		new_card.connect("remember_card", Callable(self, "_on_player_remember_card"))
		player_card_nodes.append(new_card)
		player_card_numbers.append(new_card_number)
		player_card_container.add_child(new_card)
		new_card.refresh_display()
		await get_tree().create_timer(0.5).timeout
	notice_label.set_text("Now Choose two card to check.")
	state_manager.transition_to(state_manager.GameState.CHECK)


func _process(_delta):
	pass


func _on_start_countdown_timeout():
	notice_label.set_text("Game Start, draw 4 cards.")
	add_default_cards()


func _on_draw_timer_timeout():
	# force draw a card
	_on_card_tile_draw_card()


# draw a card
func _on_card_tile_draw_card():
	var new_card = card_scene.instantiate()
	new_card.number = Global.cards.pop_front()
	new_card.card_type = Card.CardType.HAND
	hand_card.add_child(new_card)
	new_card.refresh_display()
	current_draw_card = new_card
	new_card.reveal_card()
	operation_container.show()

func _on_player_remember_card():
	notice_label.set_text("Please remember your cards in 3 seconds.")
	await get_tree().create_timer(3).timeout
	state_manager.transition_to(state_manager.GameState.DRAW)
	notice_label.set_text("Now you can draw a card.")

func _on_drop_card_btn_pressed():
	notice_label.set_text("You dropped the card[{num}] you drawed.".format({num=current_draw_card.number}))
	current_draw_card.drop()
	Global.game_round += 1
	# next round
	#operation_container.hide()
	#state_manager.transition_to(state_manager.GameState.DRAW)

func _on_exchange_card_btn_pressed():
	operation_container.hide()
	state_manager.transition_to(state_manager.GameState.EXCHANGE)
	notice_label.set_text("You choose to exchange this card with your hand cards.\nChoose a card to exchange.")


func _on_use_card_btn_pressed():
	notice_label.set_text("You choose to use this card.")
	if not current_draw_card.has_function():
		return
	# todo


func _on_player_card_drop(index):
	# replace the old card
	player_card_numbers[index] = current_draw_card.number
	player_card_nodes[index] = current_draw_card.duplicate()
	player_card_nodes[index].index = index
	player_card_nodes[index].number = current_draw_card.number
	if index == 0: # the last card
		player_card_container.add_child(player_card_nodes[index])
		player_card_container.move_child(player_card_nodes[index], 0)
	else:
		player_card_nodes[index-1].add_sibling(player_card_nodes[index])
	player_card_nodes[index].refresh_display()
	player_card_nodes[index].reveal_card()
	hand_card.remove_child(current_draw_card)
	current_draw_card.queue_free()

func _on_player_peek_card():
	state_manager.transition_to(state_manager.GameState.PEEK)
	notice_label.set_text("Choose one card of yourself to peek.")

func _on_player_spy_card():
	state_manager.transition_to(state_manager.GameState.SPY)
	notice_label.set_text("Choose one card of others to spy.")

func _on_player_swap_card():
	state_manager.transition_to(state_manager.GameState.SWAP)
	notice_label.set_text("Choose one card to swap another one.")

func _on_restart_button_pressed():
	restart()


func _on_player_card_container_mouse_entered():
	pass # Replace with function body.


func _on_player_card_container_mouse_exited():
	pass # Replace with function body.
