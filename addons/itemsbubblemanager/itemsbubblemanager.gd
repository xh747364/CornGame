@tool
extends EditorPlugin
@export var default_bubble_color := Color.WHITE  # 默认气泡颜色
@export var max_bubbles := 10  # (int, 5, 20) 最大气泡数量
@export var fade_duration := 1.0  # 渐隐时间（秒）

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
