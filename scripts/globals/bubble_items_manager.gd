extends Node

@export var max_bubbles: int = 5
@export var bubble_offset: int = 18  # 气泡间距
@export var start_position: Vector2 = Vector2(20, 20)  # 起始位置

var current_bubbles: Array = []
var bubble_scene = preload("res://scenes/ui/bubble_item_panel.tscn")
func _ready():
    # 获取屏幕尺寸并设置左下角起始位置
    var viewport_size = get_viewport().size
    start_position = Vector2(20, viewport_size.y / 2 - 80)
    print("start_position", start_position)
func show_bubble(item_name: String, count: int) -> void:
    var new_bubble = bubble_scene.instantiate()
    new_bubble.set_content("%s x%d" % [item_name, count])
    
    # 计算位置
    var base_y = start_position.y
    for bubble in current_bubbles:
        bubble.position.y += bubble_offset
    
    new_bubble.position = Vector2(start_position.x, base_y)
    get_tree().root.add_child(new_bubble)
    
    current_bubbles.push_front(new_bubble)

    # 移除超出数量的气泡
    if current_bubbles.size() > max_bubbles:
        var oldest = current_bubbles.pop_back()
        oldest.queue_free()

# 当气泡自动消失时清理数组
func _process(_delta: float) -> void:
    var valid_bubbles = []
    for bubble in current_bubbles:
        if is_instance_valid(bubble) and not bubble.is_queued_for_deletion():
            valid_bubbles.append(bubble)
    current_bubbles = valid_bubbles