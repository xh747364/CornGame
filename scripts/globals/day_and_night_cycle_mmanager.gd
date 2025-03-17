extends Node

const MINUTES_PER_DAY: int = 24 * 60
const MINUTES_PER_HOUR: int = 60
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY

var game_day_speed: float = 5
var game_night_speed: float = 10


var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30