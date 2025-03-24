extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling

var tools_list: Dictionary = {}
func _ready() -> void:
	## 初始化工具列表
	tools_list = {
		DataTypes.Tools.AxeWood: tool_axe.get_node("Panel"),
		DataTypes.Tools.WaterGrops: tool_watering_can.get_node("Panel"),
		DataTypes.Tools.PlantCorn: tool_corn.get_node("Panel"),
		DataTypes.Tools.PlantTomato: tool_tomato.get_node("Panel"),
		DataTypes.Tools.TillGround: tool_tilling.get_node("Panel")
	}
## 初始化选中工具列表
func _on_tool_selected(tool: DataTypes.Tools) -> void:
	## 取消所有工具的高亮
	for key in tools_list:
		tools_list[key].visible = false
	## 高亮选中的工具
	if tool != DataTypes.Tools.None:
		tools_list[tool].visible = true
func remove_actions() -> void:
	CustomInputManager.remove_action("hit")
func _on_tool_axe_pressed() -> void:
	remove_actions()
	_on_tool_selected(DataTypes.Tools.AxeWood)
	ToolManager.select_tool(DataTypes.Tools.AxeWood)
	CustomInputManager.restore_action("hit")
	# get_tree().get_root().set_input_as_handled()

func _on_tool_tilling_pressed() -> void:
	remove_actions()
	_on_tool_selected(DataTypes.Tools.TillGround)
	ToolManager.select_tool(DataTypes.Tools.TillGround)
	CustomInputManager.restore_action("hit")
	# get_tree().get_root().set_input_as_handled()

func _on_tool_watering_can_pressed() -> void:
	remove_actions()
	_on_tool_selected(DataTypes.Tools.WaterGrops)
	ToolManager.select_tool(DataTypes.Tools.WaterGrops)
	CustomInputManager.restore_action("hit")

func _on_tool_corn_pressed() -> void:
	remove_actions()
	_on_tool_selected(DataTypes.Tools.PlantCorn)
	ToolManager.select_tool(DataTypes.Tools.PlantCorn)
	CustomInputManager.restore_action("hit")

func _on_tool_tomato_pressed() -> void:
	remove_actions()
	_on_tool_selected(DataTypes.Tools.PlantTomato)
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)
	CustomInputManager.restore_action("hit")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		_on_tool_selected(DataTypes.Tools.None)
		ToolManager.select_tool(DataTypes.Tools.None)
		for btn in [tool_axe, tool_corn, tool_tilling, tool_tomato, tool_watering_can]:
			btn.release_focus()
