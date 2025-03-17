class_name InteractableComponent
extends Area2D

signal interactable_activated
signal interactable_deactivated


func _on_body_entered() -> void:
	interactable_activated.emit()


func _on_body_exited() -> void:
	interactable_deactivated.emit()
