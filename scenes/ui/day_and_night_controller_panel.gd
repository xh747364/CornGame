extends Control

@onready var day_label = $DayPanel/MarginContainer/Label
@onready var time_label = $TimePanel/MarginContainer/Label
@onready var season_label = $SeasonPanel/MarginContainer/Label

@export var normal_speed: int = 1
@export var fast_speed: int = 200
@export var cheetach_speed: int = 500

# 获取时间信息
func _ready():
	# 初始化时间流速
	DayTime.game_day_speed = 1
	DayTime.initialize_date(
		1,
		DayTime.Season.SUMMER,
		1,
		6,
		30
	)
	# 初始化游戏时间
	DayTime.time_updated.connect(_on_time_updated)
	DayTime.season_changed.connect(_on_season_changed)
	DayTime.daynight_changed.connect(_on_daynight_changed)

func _on_time_updated(date: DayTime.GameDate):
	# print("当前游戏时间速度：", DayTime.game_day_speed)
    # 更新天数
	day_label.text = "%d年%d日" % [date.year, date.day]
	# 更新季节
	season_label.text = str(DayTime.season_names[date.season])
	# 更新时间
	time_label.text = "%02d:%02d" % [date.hour, date.minute]


func _on_season_changed(new_season: DayTime.Season):
	print("季节变更为：", DayTime.Season.keys()[new_season])

func _on_daynight_changed(is_day: bool):
	# print("当前游戏时间速度：", DayTime.game_day_speed)
	print("现在是", "白天" if is_day else "夜晚")


func _on_cheetach_speed_button_pressed() -> void:
	DayTime.game_day_speed = cheetach_speed


func _on_fast_speed_button_pressed() -> void:
	DayTime.game_day_speed = fast_speed

func _on_normal_speed_button_pressed() -> void:
	DayTime.game_day_speed = normal_speed
