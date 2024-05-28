class_name Game
extends Node2D


var card_scene = preload("res://Card.tscn")

var cardSelected
var mouseOnPlacement = false
var current_draw_card

@onready var state_manager = $GameStateManager
@onready var hand_card = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/HandCard
@onready var operation_container = $HUD/OperationContainer
@onready var restart_button = $HUD/RestartButton
@onready var draw_deck = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/DrawDeck
@onready var discard_pile = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/DiscardPile
@onready var player = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/PlayerCards
@onready var notice_label = $HUD/NoticeLabel
@onready var enemy_1 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/Enemy1
@onready var enemy_2 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/Enemy2
@onready var enemy_3 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/Enemy3


# Called when the node enters the scene tree for the first time.
func _ready():
	operation_container.hide()
	#draw_deck.connect("draw_card", self, "_on_draw_card")

func restart():
	state_manager.transition_to(state_manager.GameState.INIT)
	Global.check_count = 0
	Global.game_round = 0
	
	operation_container.hide()
	# clear 手牌
	for child in hand_card.get_children():
		child.queue_free()
	_on_start_countdown_timeout()


func _process(_delta):
	pass


func _on_start_countdown_timeout():
	notice_label.set_text("Game Start,everyone draw 4 cards.")
	player.draw_default_cards(draw_deck.draw_cards(4))
	enemy_1.draw_default_cards(draw_deck.draw_cards(4))
	enemy_2.draw_default_cards(draw_deck.draw_cards(4))
	enemy_3.draw_default_cards(draw_deck.draw_cards(4))


func _on_draw_timer_timeout():
	# force draw a card
	_on_card_pile_draw_card()


# draw a card
func _on_card_pile_draw_card():
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
	state_manager.game_round += 1
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


func _on_player_cards_finish_draw(player_number):
	notice_label.set_text("Now Choose two card to check.")
	state_manager.transition_to(state_manager.GameState.CHECK)


func _on_player_cards_finish_replace_card():
	hand_card.remove_child(current_draw_card)
	current_draw_card.queue_free()
