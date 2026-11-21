extends Control
@onready var onscreen: RichTextLabel = $onscreen

signal boot_finished()
var Redaction50 = load("res://assets/fonts/Redaction50-Regular.ttf")
var bootlogText = """SEANCE_OS BIOS v2.04
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
	onscreen.text = "Booting SeanceOS..."
	var out = "\n"
	for c in bootlogText:
		if(c == "\n"):
			onscreen.text += out + "\n"
			out = ""
			await get_tree().create_timer(randf_range(0.2,1.4)).timeout

		else:
			out += c
	await get_tree().create_timer(3.0).timeout

	boot_finished.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
