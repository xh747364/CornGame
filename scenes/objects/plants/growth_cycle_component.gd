class_name GrowthCycleComponent
extends Node

@export var current_growth_state : DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var day_unitil_harvest : int = 7
@export var step: int = 1
signal crop_maturity
signal  crop_harvesting

var is_watered : bool
var starting_day : int
var current_day : int

func _ready():
	DayTime.time_updated.connect(_on_time_updated)


func _on_time_updated(date: DayAndNightAndTime.GameDate):
	current_day = date.day

	if is_watered:
		if starting_day == 0:
			starting_day = date.day

		growth_states(starting_day, current_day)
		harvest_state(starting_day, current_day)


func growth_states(starting_days: int, current_days: int):
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return

	var num_states: int = 5#DataTypes.GrowthStates.size()

	var growth_days_passed =  (current_days - starting_days) % num_states
	var state_index = growth_days_passed % num_states + 1

	current_growth_state = state_index
	print("Current growth state: " , current_growth_state)
	var plant_name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: " , plant_name, "State index: " , state_index)

	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()
		## emit_signal("crop_maturity")

func harvest_state(starting_days: int, current_days: int):
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	var days_passed = (current_days - starting_days) % day_unitil_harvest

	if days_passed == day_unitil_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()
		## emit_signal("crop_harvesting")

func get_current_growth_state():
	return current_growth_state
