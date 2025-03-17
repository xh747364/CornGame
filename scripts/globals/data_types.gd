class_name DataTypes

enum Tools {
	None,
	AxeWood,
	TillGround,
	WaterGrops,
	PlantCorn,
	PlantTomato
}

# 生长周期 种子->发芽->繁殖->成熟->收获
enum GrowthStates {
	Seed,
	Germination,
	Vegetatiive,
	Reproduction,
	Maturity,
	Harvesting
}

const Items: Dictionary = {
	"log": "圆木",
	"stone": "石头",
	"corn": "玉米",
	"tomato": "西红柿",
	"egg": "鸡蛋",
	"milk": "牛奶",
	"grass": "草"
}