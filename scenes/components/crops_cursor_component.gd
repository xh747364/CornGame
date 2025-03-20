class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
@onready var player: Player = get_tree().get_first_node_in_group("player")

## 加载玉米、番茄场景
var corn_scene = preload("res://scenes/objects/plants/corn.tscn")
var tomato_scene = preload("res://scenes/objects/plants/tomato.tscn")
var mouse_position: Vector2
var cell_position: Vector2
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
	elif InputMap.has_action("hit"):
		if event.is_action_pressed("hit") && ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func is_terrain_match(tilemap: TileMapLayer) -> bool:
	#判断是否在耕地的地形图块上，在的话返回true
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	# 将世界坐标转换为单元格坐标
	# 获取指定图层的 TileData（默认图层 0）
	var tile_data := tilemap.get_cell_tile_data(cell_position)
	if tile_data:
		# 检查地形集和地形类型
		return (
			tile_data.terrain_set == 0 and
			tile_data.get_terrain() == 3
		)
	return false

func add_crop() -> void:
	if distance < 20.0 && is_terrain_match(tilled_soil_tilemap_layer):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn_scene.instantiate() as Node2D
			corn_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(corn_instance)
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_scene.instantiate() as Node2D
			tomato_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(tomato_instance)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
