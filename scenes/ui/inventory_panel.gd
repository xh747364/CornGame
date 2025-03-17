extends PanelContainer

# log、stone、corn、tomato、egg、milk、grass
@onready var log_lable: Label = $MarginContainer/VBoxContainer/Log/LogLabel
@onready var stone_lable: Label = $MarginContainer/VBoxContainer/Stone/LogLabel
@onready var corn_lable: Label = $MarginContainer/VBoxContainer/Corn/LogLabel
@onready var tomato_lable: Label = $MarginContainer/VBoxContainer/Tomato/LogLabel
@onready var egg_lable: Label = $MarginContainer/VBoxContainer/Egg/LogLabel
@onready var milk_lable: Label = $MarginContainer/VBoxContainer/Milk/LogLabel
@onready var grass_lable: Label = $MarginContainer/VBoxContainer/Grass/LogLabel

func _ready():
    InventoryManager.inventory_changed.connect(on_inventory_changed)

func on_inventory_changed():
    var inventory: Dictionary = InventoryManager.inventory

    # log、stone、corn、tomato、egg、milk、grass
    if inventory.has("log"):
        log_lable.text = str(inventory["log"])
    
    if inventory.has("stone"):
        stone_lable.text = str(inventory["stone"])

    if inventory.has("corn"):
        corn_lable.text = str(inventory["corn"])

    if inventory.has("tomato"):
        tomato_lable.text = str(inventory["tomato"])

    if inventory.has("egg"):
        egg_lable.text = str(inventory["egg"])

    if inventory.has("milk"):
        milk_lable.text = str(inventory["milk"])

    if inventory.has("grass"):
        grass_lable.text = str(inventory["grass"])