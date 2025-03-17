extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent


var item_scene = preload("res://scenes/objects/rocks/stone.tscn")
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	
func on_hurt(hit_damgae: int) -> void:
	damage_component.apply_damage(hit_damgae)
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
 

func on_max_damage_reached() -> void:
	
	call_deferred("add_item_scene")
	print("max damage reached")
	queue_free()

func add_item_scene() -> void:
	var item_instance = item_scene.instantiate() as Node2D
	item_instance.global_position = global_position
	get_parent().add_child(item_instance)
