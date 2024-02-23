class_name Game
extends Node2D

var playerHbox
var notice_label
var card_tile
var hand_card

var player_cards = []
var player_cards_texture = []
var card_scene = preload("res://Card.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	hand_card = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer3/HandCard
	notice_label = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/NoticeLabel
	playerHbox = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/PlayerCardContainer
	card_tile = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/CardTile
	card_tile.card_type = "TILE"
	#card_tile.connect("draw_card", self, "_on_draw_card")

func add_default_cards():
	for i in range(4):
		var new_card = card_scene.instantiate()
		var new_card_number = Global.cards.pick_random()
		Global.cards.erase(new_card_number) # remove the card from cards
		new_card.number = new_card_number
		player_cards_texture.append(new_card)
		playerHbox.add_child(new_card)
		player_cards.append(new_card_number)
		await get_tree().create_timer(0.5).timeout
	notice_label.set_text("Now Choose two card to check.")
	Global.game_status = "CHECK"


func _process(delta):
	if Global.game_status == "REMEMBER":
		notice_label.set_text("Please remember your cards in 3 seconds.")
		await get_tree().create_timer(3).timeout
		Global.game_status = "DRAW"
		notice_label.set_text("Now you can draw a card.")


func _on_start_countdown_timeout():
	notice_label.set_text("Initial draw card.")
	add_default_cards()


func _on_draw_timer_timeout():
	pass # Replace with function body.


func _on_card_tile_draw_card():
	var new_card = card_scene.instantiate()
	new_card.number = Global.cards.pop_front()
	new_card.card_type = "HAND"
	hand_card.add_child(new_card)
	new_card.reveal_card()


func _on_drop_card_btn_pressed():
	pass # Replace with function body.


func _on_exchange_card_btn_pressed():
	pass # Replace with function body.


func _on_use_card_btn_pressed():
	pass # Replace with function body.
