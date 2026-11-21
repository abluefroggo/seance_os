extends Control

@onready var boot_sequence = $BootSequence
@onready var main_menu = $MainMenu
@onready var gameplay_screen = $GamePlayScreen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.visible = false
	gameplay_screen.visible = false
	boot_sequence.visible = true
	boot_sequence.boot_finished.connect(_on_boot_finished)


func _on_boot_finished() -> void:
	boot_sequence.visible = false
	gameplay_screen.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
