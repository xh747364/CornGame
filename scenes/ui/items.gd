extends Control
## 用于存储物品面板场景
var item_panel_scene = null
func _ready() -> void:
    item_panel_scene = get_parent().get_node("InventoryPanel")
    
func _on_item_pressed() -> void:
    CustomInputManager.remove_action("hit")
    if item_panel_scene:
        item_panel_scene.visible = !item_panel_scene.visible
    CustomInputManager.restore_action("hit")
