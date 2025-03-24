extends Node

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("save_game"):
		save_game()

func save_game():
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")

	if save_level_data_component != null:
		save_level_data_component.save_game()

func load_game():
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	if save_level_data_component!= null:
		save_level_data_component.load_game()
