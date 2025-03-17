class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day: int = 1:
	set(id):
		initial_day = id
		DayTime.current_day = id
@export var initial_hour: int = 12:
	set(id):
		initial_hour = id
		DayTime.current_hour = id
@export var initial_minute: int = 30:
	set(id):
		initial_minute = id
		DayTime.current_minute = id
@export var season: DayTime.Season = DayTime.Season.SPRING:
	set(id):
		season = id
		DayTime.current_season = id
@export var year: int = 1:
	set(id):
		year = id
		DayTime.current_year = id

# @export var day_night_gradient_texture: GradientTexture1D

func _ready():
	DayTime.current_day = initial_day
	DayTime.current_hour = initial_hour
	DayTime.current_minute = initial_minute
	DayTime.current_season = season
	DayTime.current_year = year
	DayTime.time_updated.connect(_on_time_updated)
	# DayTime.season_changed.connect(_on_season_changed)


@export var day_night_gradient_texture: GradientTexture1D
@export var season_gradients: Dictionary = {  # 新增四季渐变纹理
	DayTime.Season.SPRING: GradientTexture1D.new(),
	DayTime.Season.SUMMER: GradientTexture1D.new(),
	DayTime.Season.AUTUMN: GradientTexture1D.new(),
	DayTime.Season.WINTER: GradientTexture1D.new()
}
@export var season_blend_factor: float = 0.3  # 季节颜色混合强度
@export var overlay_opacity: float = 0.8

func _on_time_updated(date: DayTime.GameDate):
	# 将时间转换为0-1的24小时进度（包含分钟）
	var time_progress = (date.hour * 60 + date.minute) / 1440.0
	# 调整正弦波相位和周期为24小时
	var sample_value = 0.5 * (sin(time_progress * 2 * PI - PI * 0.5) + 1.0)
	color = day_night_gradient_texture.gradient.sample(sample_value)
	color.a = overlay_opacity  # 设置透明度
	# var time_progress = (date.hour * 60 + date.minute) / 1440.0
	# var sample_value = 0.5 * (sin(time_progress * 2 * PI - PI * 0.5) + 1.0)
	# # 获取基础昼夜颜色
	# var base_color = day_night_gradient_texture.gradient.sample(sample_value)
    
	# # 获取季节颜色（从字典中按当前季节获取
	# print("==season_gradients[DayTime.current_season]==", season_gradients[DayTime.current_season])
	# var season_color = season_gradients[DayTime.current_season].gradient.sample(sample_value)
    # # 混合颜色
	# color = base_color.lerp(season_color, season_blend_factor)
	# color.a = overlay_opacity


# func _on_season_changed():
	# 季节变化时强制更新颜色
	# _on_time_updated(DayTime.current_date)