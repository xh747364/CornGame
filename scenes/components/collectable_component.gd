class_name CollectableComponent
extends Area2D

@export var collectable_name: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		print("Collected:", body.name, body.position)
		var current_count = 1
		## 收集时候显示气泡
		BubbleItemsManager.show_bubble(DataTypes.Items[collectable_name], current_count)

		get_parent().queue_free()