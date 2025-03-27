extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_smile", "emote_3_ear_wave", "emote_4_blink"]

func _ready():
	animated_sprite_2d.play("emote_1_idle")

func play_emote(animation: String):
	animated_sprite_2d.play(animation)

func _on_emote_idle_timer_timeout():
	var random_emote = idle_emotes[randi() % idle_emotes.size()]
	animated_sprite_2d.play(random_emote)