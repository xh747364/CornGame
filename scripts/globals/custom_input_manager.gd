extends Node

# 保存输入事件的字典
var input_events: Dictionary = {}
var can_process_input: bool = true
# 删除输入映射并保存事件
func remove_action(action_name: String):
	# 检查输入映射是否存在
	if InputMap.has_action(action_name):
		var events = InputMap.action_get_events(action_name)
		if events.size() > 0:
			input_events[action_name] = events[0]  # 保存第一个事件
			InputMap.erase_action(action_name)  # 删除输入映射
			print("删除输入映射: ", action_name)
		else:
			print("没有找到输入事件: ", action_name)
	else:
		print("输入映射不存在: ", action_name)

# 恢复输入映射
func restore_action(action_name: String):
	get_tree().create_timer(0.1).timeout.connect(func(): restore_all_actions(action_name))

func restore_all_actions(action_name: String):
	InputMap.add_action(action_name)
	if input_events.has(action_name):
		InputMap.action_add_event(action_name, input_events[action_name])  # 使用已保存的事件实例
		print("恢复输入映射: ", action_name)
	else:
		print("没有可恢复的输入事件: ", action_name)