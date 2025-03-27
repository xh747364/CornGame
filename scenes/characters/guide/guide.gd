extends Node2D

# 预加载dialogue场景
var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
# 加载碰撞组件
@onready var interactable_component: InteractableComponent = $InteractableComponent
# 加载交互组件
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var player: Player = get_tree().get_first_node_in_group("player")

# 显示交互标签
var in_range = false
func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	# 隐藏交互标签
	interactable_label_component.hide()
	GameDialogueManager.give_crop_seeds.connect(on_give_crop_seeds)
func on_interactable_activated():
	# 计算玩家相对位置
	var player_pos = player.global_position
	var guide_pos = global_position
	
	# 判断水平方向
	var horizontal_offset = Vector2(0, 0) if player_pos.x < guide_pos.x else Vector2(-20, 0)
	# 判断垂直方向
	var vertical_offset = Vector2(0, 0) if player_pos.y < guide_pos.y else Vector2(0, -20)
	
	# 比较水平和垂直方向的偏移优先级
	if abs(player_pos.x - guide_pos.x) > abs(player_pos.y - guide_pos.y):
		interactable_label_component.position = horizontal_offset
	else:
		interactable_label_component.position = vertical_offset
	# 显示交互标签
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated():
	# 隐藏交互标签
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/guide.dialogue"), "start")

func on_give_crop_seeds():
	for tool in DataTypes.Tools:
		ToolManager.enable_tool_button(DataTypes.Tools[tool])
