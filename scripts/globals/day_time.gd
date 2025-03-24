extends Node
class_name DayAndNightAndTime

## 信号定义
signal season_changed(new_season: Season)
signal time_updated(date: GameDate)
signal daynight_changed(is_day: bool)

## 季节枚举
enum Season { SPRING, SUMMER, AUTUMN, WINTER }
var season_names = {
	Season.SPRING: "春",
	Season.SUMMER: "夏",
	Season.AUTUMN: "秋",
	Season.WINTER: "冬"
}
## 游戏日期结构体
class GameDate:
	var year: int
	var season: Season
	var day: int
	var hour: int
	var minute: int
	
	func _to_string() -> String:
		return "Year %d | %s Day %d | %02d:%02d" % [
			year,
			Season.keys()[season].capitalize(),
			day,
			hour,
			minute
		]

## 导出变量
@export_range(1, 60) var real_seconds_per_game_minute: float = 1.0:
	set(value):
		real_seconds_per_game_minute = clamp(value, 0.1, 60.0)

@export var enable_season_cycle: bool = true
@export var days_per_season: int = 7
@export var day_start_hour: int = 6
@export var night_start_hour: int = 20

@export var current_hour: int = 6
@export var current_minute: int = 0
@export var current_year: int = 1
@export var current_season: Season = Season.SPRING
@export var current_day: int = 1

## 全局时间流速
var game_day_speed: float = 150.0
## 时间流速配置
var time_speeds = {
	Season.SPRING: {day = 1.2, night = 0.8},
	Season.SUMMER: {day = 1.5, night = 1.0},
	Season.AUTUMN: {day = 1.0, night = 1.2},
	Season.WINTER: {day = 0.8, night = 1.5}
}

## 运行时变量
var accumulated_time: float = 0.0
var current_date := GameDate.new()
var is_day: bool = true
var game_paused: bool = false

func _ready():
	# 默认初始化（可被覆盖）
	initialize_date(current_year, current_season, current_day, current_hour, current_minute)

func initialize_date(year: int = current_year, season: Season = current_season, day: int = current_day, hour: int = current_hour, minute: int = current_minute):
	""" 初始化游戏日期并重置时间系统 """
	var days_in_cycle = days_per_season * 4
	var total_days = (year - 1) * days_in_cycle + (season as int) * days_per_season + (day - 1)
	var total_minutes = total_days * 24 * 60 + hour * 60 + minute
	
	accumulated_time = total_minutes
	print("==accumulated_time==", accumulated_time)
	# 强制更新状态
	_update_game_date()
	_update_daynight_status()
	
	# 发送初始信号
	time_updated.emit(current_date)
	season_changed.emit(current_date.season)
	daynight_changed.emit(is_day)

func _process(delta: float):
	if game_paused:
		return
	
	# 计算实际时间流逝
	var real_time_elapsed = delta / real_seconds_per_game_minute
	
	# 应用昼夜流速系数
	var time_modifier = _get_current_time_modifier()
	var game_minutes_elapsed = real_time_elapsed * time_modifier
	
	# 更新累计时间
	accumulated_time += game_minutes_elapsed
	
	# 更新时间信息
	_update_game_date()
	_update_daynight_status()
	
	# 发送时间更新信号
	time_updated.emit(current_date)

func _update_game_date():
	var total_minutes = accumulated_time
	current_date.minute = int(total_minutes) % 60
	current_date.hour = int(total_minutes / 60) % 24
	var total_hours = int(total_minutes / 60)
	var total_days = int(total_hours / 24)
	
	var days_in_cycle = days_per_season * 4
	var days_in_current_cycle = total_days % days_in_cycle
	
	var prev_season = current_date.season
	
	# 季节计算
	if enable_season_cycle:
		current_date.season = days_in_current_cycle / days_per_season
	
	# 日期计算
	current_date.day = (days_in_current_cycle % days_per_season) + 1
	
	# 年份计算
	current_date.year = (total_days / days_in_cycle) + 1
	
	# 触发季节变更信号
	if enable_season_cycle && current_date.season != prev_season:
		season_changed.emit(current_date.season)

func _update_daynight_status():
	var was_day = is_day
	is_day = current_date.hour >= day_start_hour && current_date.hour < night_start_hour
	
	if was_day != is_day:
		daynight_changed.emit(is_day)

func _get_current_time_modifier() -> float:
	var time_speed = time_speeds[current_date.season]
	return time_speed.day * game_day_speed if is_day else time_speed.night * game_day_speed

func set_time_speed(season: Season, day_speed: float, night_speed: float):
	time_speeds[season] = {day = day_speed, night = night_speed}

func toggle_pause():
	game_paused = !game_paused

func get_current_date() -> GameDate:
	return current_date

func get_current_season() -> Season:
	return current_date.season

func is_daytime() -> bool:
	return is_day
