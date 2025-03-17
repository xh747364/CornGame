extends Control

@onready var item_button: Button = $MarginContainer/ItemButton
## 用于存储物品面板场景
var item_panel_scene = null  
func _ready() -> void:
    item_panel_scene = get_parent().get_node("InventoryPanel")
    
func _on_item_pressed() -> void:
    if item_panel_scene:
        item_panel_scene.visible = !item_panel_scene.visible
    
