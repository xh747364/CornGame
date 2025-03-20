class_name GameInputEvents

static var direction: Vector2

static func movement_input() -> Vector2:
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN
	else:
		direction = Vector2.ZERO
	
	return direction



static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func use_tool() -> bool:
	var use_tool_value: bool = false
	if InputMap.has_action("hit"):  # 检查输入映射是否存在
		if Input.is_action_just_pressed("hit"):
            # 执行相关逻辑
			use_tool_value = Input.is_action_just_pressed("hit")
			print("使用工具")
	else:
		use_tool_value = false
		print("输入映射 'hit' 不存在，无法使用工具")
	
	
	return use_tool_value
