extends Control
## 用于存储物品面板场景
var item_panel_scene = null
func _ready() -> void:
    item_panel_scene = get_parent().get_node("InventoryPanel")
    
# func _on_item_pressed() -> void:
#     CustomInputManager.remove_action("hit")
#     if item_panel_scene:
#         item_panel_scene.visible = !item_panel_scene.visible
#     CustomInputManager.restore_action("hit")

func _on_item_gui_input(event:InputEvent) -> void:
    accept_event()
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            CustomInputManager.remove_action("hit")
            if item_panel_scene:
                item_panel_scene.visible = !item_panel_scene.visible
            # print("我已被点击 D:")
            CustomInputManager.restore_action("hit")
    