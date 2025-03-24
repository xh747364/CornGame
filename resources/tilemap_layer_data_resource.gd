class_name TilemapLayerDataResource
extends NodeDataResource

@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 3

func _save_data(node: Node2D):
	super._save_data(node)
	var tilemap_layer: TileMapLayer = node as TileMapLayer
	if !tilemap_layer:
		printerr("保存失败：请选择 TileMapLayer 节点（当前选中的是 %s）" % node.get_class())
		return
	var cells: Array[Vector2i] = tilemap_layer.get_used_cells()

	tilemap_layer_used_cells = cells

func _load_data(window: Window):
	var scene_node = window.get_node_or_null(node_path)
	if scene_node != null:
		var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
		print("==scene_node2==", tilemap_layer)
		tilemap_layer.set_cells_terrain_connect(tilemap_layer_used_cells, terrain_set, terrain, true)
