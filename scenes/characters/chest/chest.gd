extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_maker: Marker2D = $RewardMaker
# 预加载气泡场景
var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

# 预加载玉米收割场景
var corn_harvest_scene = preload("res://scenes/objects/plants/corn_harvest.tscn")


@export var dialogue_start_commed: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scene: Array[PackedScene] = []

# 显示交互标签
var in_range = false
# 设置宝箱状态
var chest_state = false
func _ready():
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)
	feed_component.food_received.connect(on_food_received)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	if chest_state:
		animated_sprite_2d.play("chest_close")
		chest_state = false
	interactable_label_component.hide()
	in_range = false

# 宝箱状态改变
func _on_ChestStateChanged() -> void:
	if chest_state:
		animated_sprite_2d.play("chest_open")
	else:
		animated_sprite_2d.play("chest_close")
func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			interactable_label_component.hide()
			chest_state = true
			animated_sprite_2d.play("chest_open")

			# 创建气泡
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/chest.dialogue"), dialogue_start_commed)

# 喂动物
func on_feed_the_animals():
	if in_range:
		trigger_feed_harvest("corn", corn_harvest_scene)

func trigger_feed_harvest(inventory_item: String, scene: Resource):
	var inventory: Dictionary = InventoryManager.inventory

	if !inventory.has(inventory_item):
		return

	var inventory_item_count = inventory[inventory_item]

	for index in inventory_item_count:
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)

		var target_position = global_position
		var time_delay = randf_range(0.5, 2.0)
		await get_tree().create_timer(time_delay).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(harvest_instance, "position", target_position, 1.0)
		tween.tween_property(harvest_instance, "scale", Vector2(0.5, 0.5), 1.0)
		tween.tween_callback(harvest_instance.queue_free)

		InventoryManager.remove_collectable(inventory_item)

# on_food_received
func on_food_received(_area: Area2D):
	# 调用add_reward_scene
	call_deferred("add_reward_scene")

func add_reward_scene():
	for scene in output_reward_scene:
		var reward_scene: Node2D = scene.instantiate()
		var random_position: Vector2 = get_random_position_in_circle(reward_maker.global_position, reward_output_radius)
		reward_scene.global_position = random_position
		get_tree().root.add_child(reward_scene)
		print("random_position", random_position)

# 计算奖励随机位置
func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU

	var distance_from_center = sqrt(randf()) * radius

	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * cos(angle)
	return Vector2i(x, y)
