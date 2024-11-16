extends Control

var enemy_dropdown: OptionButton
var card_container: PanelContainer
var draw_button: Button
var selected_enemy: String
var cards: Array = []
var original_cards: Array = []  # New array to store the original cards

var current_enemy: String
var no_more_cards_label
var card_display
var cards_shuffled_label
var enemy_stats: Dictionary  # To store enemy details like stats
var health_value: int = 0  # Initialize health_value
var attack_value: int = 0 
var defense_value: int = 0 
var ap_value: int = 0 
var attack_value_current: int = 0 
var defense_value_current: int = 0 
var ap_value_current: int = 0 
var initial_ap_value: int = 0



@onready var elements_to_toggle := [
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer3,
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer4,
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer5,
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer7,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer10,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer2,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer3,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer4,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer7,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer8,
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HSeparator2,
	$Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HSeparator3,
	
]

var card_history: Array = []

@onready var undo_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer/UndoButton

@onready var enemy_display_name = $Panel/MarginContainer/HBoxContainer/AIContainer/EnemyName
@onready var enemy_health_initial = $Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer14/HealthINITIAL
@onready var enemy_health_current = $Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer/HealthCURRENT
@onready var enemy_shield_initial = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer15/DefenseINITIAL
@onready var enemy_shield_current = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer12/DefenceVALUE
@onready var enemy_attack_initial = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer16/AttackINITIAL
@onready var enemy_attack_current = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer11/AttackVALUE
@onready var enemy_ap_initial = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer17/APINITIAL
@onready var enemy_ap_current = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer13/APValue

@onready var health_up_button = $Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer/HealthINC
@onready var health_down_button = $Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer/HealthDEC
@onready var attack_up_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer11/AttackINC
@onready var attack_down_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer11/AttackDEC
@onready var defense_up_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer12/DefenseINC
@onready var defense_down_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer12/DefenseDEC
@onready var ap_up_button = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer13/APINC
@onready var ap_down_button = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer13/APDEC
@onready var ap_reset_button = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer15/APReset

@onready var reset_spinboxes_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/ResetSpinBoxes

@onready var toggle_chip_visibility = $Panel/MarginContainer/HBoxContainer/CONTContainer/VBoxContainer/HBoxContainer/CheckButton

@onready var green_cubes_current = $Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer9/SpinBoxGREENCUBES

func _ready():
	# Reference the dropdown, button, and container
	enemy_dropdown = $Panel/MarginContainer/HBoxContainer/AIContainer/EnemyDropdown  # Adjust the path if necessary
	card_container = $Panel/MarginContainer/HBoxContainer/AIContainer/HBoxContainer2/VBoxContainer2/CardDisplay
	draw_button = $Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer/DrawButton
	no_more_cards_label = $Panel/MarginContainer/HBoxContainer/AIContainer/HBoxContainer2/VBoxContainer2/NoMoreCardsLabel
	card_display = $Panel/MarginContainer/HBoxContainer/AIContainer/HBoxContainer2/VBoxContainer2/CardDisplay
	cards_shuffled_label = $Panel/MarginContainer/HBoxContainer/AIContainer/HBoxContainer2/VBoxContainer2/CardsShuffledLabel
	#reset_spinboxes_button = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/ResetSpinBoxes
	# Connect the undo button
	undo_button.connect("pressed", Callable(self, "_on_undo_button_pressed"))
	
	# Initial UI state
	undo_button.disabled = true  # Disable undo until there's something to undo



	# Connect signals
	#enemy_dropdown.connect("item_selected", Callable(self, "_on_enemy_selected"))
	draw_button.connect("pressed", Callable(self, "_draw_card"))

	no_more_cards_label.visible = false
	card_display.visible = false
	cards_shuffled_label.visible = false

	# Connect the buttons to their respective functions
	health_up_button.connect("pressed", Callable(self, "_on_health_up_button_pressed"))
	health_down_button.connect("pressed", Callable(self, "_on_health_down_button_pressed"))
	attack_up_button.connect("pressed", Callable(self, "_on_attack_up_button_pressed"))
	attack_down_button.connect("pressed", Callable(self, "_on_attack_down_button_pressed"))
	defense_up_button.connect("pressed", Callable(self, "_on_defense_up_button_pressed"))
	defense_down_button.connect("pressed", Callable(self, "_on_defense_down_button_pressed"))
	ap_up_button.connect("pressed", Callable(self, "_on_ap_up_button_pressed"))
	ap_down_button.connect("pressed", Callable(self, "_on_ap_down_button_pressed"))
	ap_reset_button.connect("pressed", Callable(self, "_on_ap_reset_pressed"))

	reset_spinboxes_button.connect("pressed", Callable(self, "_on_reset_spinboxes_pressed"))
	

	Global.connect("visibility_toggled", Callable(self, "toggle_elements_visibility"))
	toggle_elements_visibility(Global.is_visible)
	

func set_enemy_data(enemy_name: String) -> void:
	# Fetch enemy stats based on the enemy_name
	#var enemy_stats = get_enemy_stats(enemy_name)
	print(enemy_name)
	# Check if stats were found
	if enemy_stats.size() > 0:
		self.enemy_stats = enemy_stats  # Store the enemy stats
		update_enemy_display()  # Call the method to update the enemy display with these stats
		print(enemy_name)
	else:
		print("No stats found for enemy: ", enemy_name)

func get_enemy_stats(enemy_name: String) -> Dictionary:
	if getdata.enemydata.has(enemy_name):
		return getdata.enemydata[enemy_name]  # Return the enemy's data (as a Dictionary)
	print(enemy_name)
	return {}  # Return an empty dictionary if no data is found

func update_enemy_display() -> void:
	# This function updates the UI with the enemy stats (display on the card or container)
	# Retrieving stats from the JSON data (enemy_stats should contain integer values)
	#update_elements_to_toggle()
	var initial_attack_value = enemy_stats.get("Attack", 0)
	var initial_shield_value = enemy_stats.get("Shield", 0)
	var initial_health_value = enemy_stats.get("Health", 0)  # Get initial health value
	var initial_ap_value = enemy_stats.get("AP", 0)
	var rewards = enemy_stats.get("BothRewards")

	if enemy_stats:
		# Set various labels or other UI elements to show enemy data
		enemy_display_name.text = "[center]" + str(enemy_stats.get("NewName", "Unknown Enemy")) + "\n" + str(enemy_stats.get("BothRewards", "Unknown Enemy")) + "[/center]"
		enemy_attack_current.text = str(initial_attack_value)
		enemy_attack_initial.text = str(initial_attack_value)  
		enemy_shield_current.text = str(initial_shield_value)
		enemy_shield_initial.text = str(initial_shield_value)
		enemy_health_initial.text = str(initial_health_value)
		
		enemy_ap_current.text = str(initial_ap_value)
		enemy_ap_initial.text = str(initial_ap_value)
		#print("Initial AP set to:", initial_ap_value)

		# Don't overwrite current health during display updates
		if health_value == 0:
			health_value = initial_health_value  # Set health_value only if not already set
		enemy_health_current.text = str(health_value)  # Set current health value

		
		if attack_value == 0:
			attack_value = initial_attack_value 
		enemy_attack_current.text = str(attack_value)
		
		
		if defense_value == 0:
			defense_value = initial_shield_value
		enemy_shield_current.text = str(defense_value)
		
		
		if ap_value == 0:
			ap_value = initial_ap_value  # Set ap_value only if not already set
		enemy_ap_current.text = str(ap_value)  # Set current ap value
		
		
		if initial_ap_value == 0:  # Set initial_ap_value only once
			initial_ap_value = initial_ap_value
			print("Initial AP set to:", initial_ap_value)






	else:
		print("No enemy stats to display")


func _on_enemy_selected(enemy_name: String) -> void:
	selected_enemy = enemy_name
	print("Selected enemy: ", selected_enemy)
	current_enemy = selected_enemy
	load_enemy_cards(selected_enemy)

func load_enemy_cards(enemy_name: String) -> void:
	enemy_stats = get_enemy_stats(enemy_name)
	print("Enemy Name to get Stats: ", enemy_name)
	if enemy_stats.size() > 0:
		cards.clear()
		original_cards.clear()  # Clear the original cards as well

		# Construct the folder name dynamically from the enemy name
		var folder_name = enemy_name.replace(" ", "").replace("⭐", "") + "AICards"

		load_enemy_card_scenes(folder_name, enemy_stats)
		shuffle_cards(cards)  # Shuffle cards after loading them
		update_enemy_display()  # Update display with the enemy's stats

		print(enemy_name)
	else:
		print("No stats found for enemy: ", enemy_name)

func load_enemy_card_scenes(folder_name: String, _enemy_stats: Dictionary) -> void:
	for i in range(1, 9):  # Assuming there are 8 cards per enemy
		var card_path = "res://Scenes/EnemyAICards/%s/Card%d.tscn" % [folder_name, i]
		var card_scene = load(card_path)
		if card_scene:
			var card_instance = card_scene.instantiate()
			cards.append(card_instance)
			original_cards.append(card_instance.duplicate())  # Save a duplicate of the original card
			print("Card loaded: ", card_path.get_file())  # Will give the file name like Card1.tscn
		else:
			print("Failed to load card: ", card_path)

func shuffle_cards(cards: Array) -> void:
	# Repopulate the cards array from the original set
	cards.clear()
	for card in original_cards:
		cards.append(card.duplicate())  # Ensure each card is a new instance

	# Shuffle the array
	var card_count = cards.size()
	for i in range(card_count):
		var rand_index = randi() % card_count
		var temp = cards[i]
		cards[i] = cards[rand_index]
		cards[rand_index] = temp

func _draw_card() -> void:
	card_display.visible = true
	cards_shuffled_label.visible = false
	if cards.size() > 0:
		# Save the currently visible card to history
		if card_container.get_child_count() > 0:
			var current_card = card_container.get_child(0)
			card_history.append(current_card.duplicate())  # Save a duplicate of the current card

		# Draw the next card
		var card_instance = cards.pop_front()
		
		if card_instance:
			fade_card(card_instance)
		else:
			print("Warning: No valid card instance to draw!")
		
		# Enable undo button
		undo_button.disabled = card_history.size() == 0
	else:
		no_more_cards_label.visible = true
		card_display.visible = false
		print("No more cards to draw!")

func fade_card(card_instance: Control) -> void:
	# Ensure the card instance is valid before proceeding
	if card_instance:
		for child in card_container.get_children():
			child.queue_free()  # Free existing children in the container

		card_container.add_child(card_instance)
		card_instance.modulate.a = 0  # Start with full transparency

		var tween = create_tween()
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.5)  # Fade in over 0.5 seconds
	else:
		print("Warning: Attempted to fade a freed card instance!")

func _on_shuffle_button_pressed() -> void:
	no_more_cards_label.visible = false
	cards_shuffled_label.visible = true

	print("Current Enemy is: ", current_enemy)
	shuffle_cards(cards)
	print("Cards Shuffled: ", cards)

func _on_health_up_button_pressed():
	health_value += 1
	update_health_display()

func _on_health_down_button_pressed():
	if health_value > 0:
		health_value -= 1
	update_health_display()

func _on_attack_up_button_pressed():
	attack_value += 1
	update_attack_display()

func _on_attack_down_button_pressed():
	if attack_value > 0:
		attack_value -= 1
	update_attack_display()

func _on_defense_up_button_pressed():
	defense_value += 1
	update_defense_display()

func _on_defense_down_button_pressed():
	if defense_value > 0:
		defense_value -= 1
	update_defense_display()

func _on_ap_up_button_pressed():
	ap_value += 1
	update_ap_display()

func _on_ap_down_button_pressed():
	if ap_value > -green_cubes_current.value:
		ap_value -= 1
	update_ap_display()






func _on_ap_reset_pressed():
	var initial_ap_value = enemy_stats.get("AP", 0)
	ap_value = initial_ap_value
	update_ap_display()
	print("AP reset to initial value:", ap_value)

func update_health_display():
	enemy_health_current.text = str(health_value)  # Update the displayed health value

func update_attack_display():
	enemy_attack_current.text = str(attack_value)

func update_defense_display():
	enemy_shield_current.text = str(defense_value)

func update_ap_display():
	enemy_ap_current.text = str(ap_value)

func _on_reset_spinboxes_pressed() -> void:
	
	$Panel/MarginContainer/HBoxContainer/HealthContainer/VBoxContainer/HBoxContainer10/SpinBoxEVASION.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer/HBoxContainer11/SpinBoxFREEZE.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer2/HBoxContainer12/SpinboxPOISON.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer3/HBoxContainer11/SpinBoxFEAR.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer4/HBoxContainer12/SpinBoxSEAL.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer7/SpinBoxUPKEEP.value = 0
	$Panel/MarginContainer/HBoxContainer/HealthContainer/HBoxContainer8/SpinBoxSTUN.value = 0
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer3/SpinBoxSTRENGTHEN.value = 0
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer4/SpinBoxWEAKEN.value = 0
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer5/SpinBoxBOLSTER.value = 0
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer7/SpinBoxBREAK.value = 0
	$Panel/MarginContainer/HBoxContainer/CONTContainer/HBoxContainer6/SpinBoxBLUECUBES.value = 0
	
	


func _on_undo_button_pressed() -> void:
	if card_history.size() == 0:
		print("Nothing to undo!")
		return

	# Restore the last card from the history
	var last_card = card_history.pop_back()

	# Clear current card display
	for child in card_container.get_children():
		child.queue_free()

	# Display the restored card
	card_container.add_child(last_card)
	last_card.modulate.a = 1  # Ensure it's fully visible

	# Disable undo if no more history is available
	undo_button.disabled = card_history.size() == 0
	print("Undo successful! Restored card:", last_card.name)




func toggle_elements_visibility(visible: bool) -> void:
	print("Toggling elements visibility:", visible)

	for element in elements_to_toggle:
		if element:  # Ensure the element is valid
			element.visible = visible
			print("Updated element:", element.name, "Visible:", element.visible)  # Debug each element
