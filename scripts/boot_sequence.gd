extends Control
@onready var onscreen: RichTextLabel = $onscreen

signal boot_finished()
var Redaction50 = load("res://assets/fonts/Redaction50-Regular.ttf")
var bootlogText = """Booting SeanceOS...
SEANCE_OS BIOS v2.04
Initializing hardware...
Checking memory........ [color=green]OK[/color]
Loading kernel......... [color=green]OK[/color]
Mounting filesystem.... [color=green]OK[/color]
Starting processes...
PID     PROCESS
0001     [color=#FFBF00][UNKNOWN][/color]
0002     kernel
0003     firewall
0004     ...
[color=red]WARNING: PROCESS 0001 IS UNRESPONSIVE[/color]
[color=red]WARNING: UNRECOGNIZED SYSTEM PROCESS[/color]"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	onscreen.bbcode_enabled = true
	onscreen.add_theme_font_override("normal_font", Redaction50)
	var out = ""
	for c in bootlogText:
		if(c == "\n"):
			onscreen.text += out + "\n"
			out = ""
			await get_tree().create_timer(randf_range(0.2,0.8)).timeout
		elif(c == " "):
			onscreen.text += out
			out = " "
			await get_tree().create_timer(0.15).timeout
		
		else:
			out += c
	onscreen.text += out
	await get_tree().create_timer(1.0).timeout

	boot_finished.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				onscreen.text = bootlogText
				await get_tree().create_timer(1.0).timeout
				boot_finished.emit()
