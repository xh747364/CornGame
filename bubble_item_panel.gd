extends Control

func set_content(text: String) -> void:
    $Label.text = text

func _ready() -> void:
    $Timer.wait_time = 3
    $Timer.start()
    $Timer.timeout.connect(queue_free)