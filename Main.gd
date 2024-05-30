class_name Game
extends Node2D


var card_scene = preload("res://Card.tscn")

var cardSelected
var mouseOnPlacement = false
var current_draw_card

@onready var state_manager = $GameStateManager
@onready var operation_container = $HUD/OperationContainer
@onready var restart_button = $HUD/RestartButton
@onready var draw_deck = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/DrawDeck
@onready var discard_pile = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/DiscardPile
@onready var player = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/PlayerCards
@onready var notice_label = $HUD/NoticeLabel
@onready var enemy_1 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/Enemy1
@onready var enemy_2 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/Enemy2
@onready var enemy_3 = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/Enemy3
@onready var hand_card = $ColorRect/HandCard


# Called when the node enters the scene tree for the first time.
func _ready():
	operation_container.hide()
	state_manager.transition_to(state_manager.GameState.INIT)
	#draw_deck.connect("draw_card", self, "_on_draw_card")

func restart():
	state_manager.transition_to(state_manager.GameState.INIT)
	Global.check_count = 0
	state_manager.game_round = 0
	player.restart()
	enemy_1.restart()
	enemy_2.restart()
	enemy_3.restart()
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
	if state_manager.current_state == state_manager.GameState.DRAW:
		draw_deck.draw_cards_in_turn()


# draw a card
func _on_card_pile_draw_card(card):
	var new_card = card_scene.instantiate()
	new_card.init(card, 0, Card.CardType.HAND)
	hand_card.add_child(new_card)
	current_draw_card = new_card
	new_card.reveal_card()
	operation_container.show()
	state_manager.transition_to(state_manager.GameState.OPERATE)
	
# different operation
func _on_drop_card_btn_pressed():
	# 丢弃抽到的手牌
	notice_label.set_text("You dropped the card[{num}] you drawed just now.".format({num=current_draw_card.number}))
	current_draw_card.drop()
	state_manager.game_round += 1
	# next round
	operation_container.hide()
	# TODO 其他玩家操作
	# state_manager.transition_to(state_manager.GameState.DRAW)

func _on_exchange_card_btn_pressed():
	# 交换手牌
	operation_container.hide()
	state_manager.transition_to(state_manager.GameState.EXCHANGE)
	notice_label.set_text("You choose to exchange this card with your hand cards.\nChoose a card to exchange.")


func _on_use_card_btn_pressed():
	if not current_draw_card.has_function():
		notice_label.set_text("This card doesn't have any function.")
		return
	else:
		notice_label.set_text("You choose to use this card.")
		current_draw_card.use_function()
		operation_container.hide()


func _on_restart_button_pressed():
	restart()


func _on_player_cards_finish_replace_card():
	hand_card.remove_child(current_draw_card)
	current_draw_card.queue_free()


func _on_player_cards_finish_peek_card():
	current_draw_card.drop()
	state_manager.game_round += 1
	# next round
