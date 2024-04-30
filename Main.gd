class_name Game
extends Node2D

var player_card_numbers = []
var current_draw_card
var player_card_nodes = []
var card_scene = preload("res://Card.tscn")

@onready var hand_card = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/HandCard
@onready var notice_label = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/NoticeLabel
@onready var card_tile = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/CardTile
@onready var player_card_container = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/PlayerCardContainer
@onready var hud = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.hide()
	card_tile.card_type = Card.CardType.TILE
	#card_tile.connect("draw_card", self, "_on_draw_card")

func restart():
	Global.game_status = Global.Status.INIT
	Global.check_count = 0
	Global.game_round = 0
	player_card_numbers = []
	player_card_nodes = []
	hud.hide()
	# clear all children in player_card_container
	for child in player_card_container.get_children():
		child.queue_free()

func add_default_cards():
	for i in range(4):
		var new_card = card_scene.instantiate()
		var new_card_number = Global.cards.pick_random()
		Global.cards.erase(new_card_number) # remove the card from cards
		new_card.number = new_card_number
		new_card.index = i
		new_card.connect("drop_card", Callable(self, "_on_player_card_drop"))
		player_card_nodes.append(new_card)
		player_card_numbers.append(new_card_number)
		player_card_container.add_child(new_card)
		await get_tree().create_timer(0.5).timeout
	notice_label.set_text("Now Choose two card to check.")
	Global.game_status = Global.Status.CHECK


func _process(_delta):
	print(player_card_numbers)
	if Global.game_status == Global.Status.REMEMBER:
		notice_label.set_text("Please remember your cards in 3 seconds.")
		await get_tree().create_timer(3).timeout
		Global.game_status = Global.Status.DRAW
		notice_label.set_text("Now you can draw a card.")


func _on_start_countdown_timeout():
	notice_label.set_text("Game Start, draw 4 cards.")
	add_default_cards()


func _on_draw_timer_timeout():
	# force draw a card
	_on_card_tile_draw_card()


func _on_card_tile_draw_card():
	var new_card = card_scene.instantiate()
	new_card.number = Global.cards.pop_front()
	new_card.card_type = Card.CardType.HAND
	hand_card.add_child(new_card)
	current_draw_card = new_card
	new_card.reveal_card()
	hud.show()


func _on_drop_card_btn_pressed():
	notice_label.set_text("You dropped the card[{num}] you drawed.".format({num=current_draw_card.number}))
	current_draw_card.drop()
	Global.game_round += 1
	# next round
	hud.hide()
	Global.game_status = Global.Status.DRAW

func _on_exchange_card_btn_pressed():
	hud.hide()
	Global.game_status = Global.Status.EXCHANGE
	notice_label.set_text("You choose to exchange this card with your hand cards.")
	await get_tree().create_timer(1).timeout
	notice_label.set_text("Choose a card to exchange.")


func _on_use_card_btn_pressed():
	notice_label.set_text("You choose to use this card.")
	# check if the card has function and use the function


func _on_player_card_drop(index):
	if Global.game_status == Global.Status.EXCHANGE:
		player_card_numbers[index] = current_draw_card.number
		player_card_nodes[index] = current_draw_card.duplicate()
		if index == 3:
			player_card_container.add_child(player_card_nodes[index])
		else:
			player_card_nodes[index+1].add_sibling(player_card_nodes[index])
		hand_card.remove_child(current_draw_card)
		current_draw_card.queue_free()
