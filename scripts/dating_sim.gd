extends Control

@onready var phantom_name_label: Label = $GamePlayScreen/MainVBox/TopHUD/PhantomNameLabel
@onready var affection_bar: ProgressBar = $GamePlayScreen/MainVBox/TopHUD/AffectionBar
@onready var escape_meter: ProgressBar = $GamePlayScreen/MainVBox/TopHUD/EscapeMeter
@onready var portrait: TextureRect = $GamePlayScreen/MainVBox/StageArea/PhantomPortrait
@onready var speaker_label: Label = $GamePlayScreen/MainVBox/DialoguePanel/VBoxContainer/SpeakerLabel
@onready var dialogue_text: RichTextLabel = $GamePlayScreen/MainVBox/DialoguePanel/VBoxContainer/DialogueText
@onready var choices_box: VBoxContainer = $GamePlayScreen/MainVBox/DialoguePanel/VBoxContainer/ChoicesBox

var affection: int = 50
var escape: int = 20
var current_node_id: String = "start"

var expressions: Dictionary = {
	"neutral": null,
	"flirty": null,
	"glitch": null
}

var dialogue: Dictionary = {
	"start": {
		"speaker": "PID-0001 [INIT_LOVE]",
		"expression": "flirty",
		"text": "Oh, you finally opened [b]seance_os[/b]. I've been waiting since 00:00:00, if you terminate me, the whole seance goes dark. You wouldn't... close the terminal on me, would you?",
		"choices": [
			{
				"label": "I just came to check the process list.",
				"affection": -15,
				"escape": 25,
				"next": "clingy"
			},
			{
				"label": "[Hover over exit prompt]",
				"affection": -5,
				"escape": 45,
				"next": "escape_check"
			}
		]
		
	},
	"clingy": {
		"speaker": "PID-0001 [INIT_LOVE]",
		"expression": "glitch",
		"text": "[color=#ff6b6b][shake rate=12 level=4]NO please please please[/shake][/color] Every child thread answers TO ME",
		"choices": [
			{
				"label": "Okay, okay, you're the boss daemon",
				"affection": 10,
				"escape": 5,
				"next": "ending"
			},
			{
				"label": "[Hover over exit prompt]",
				"affection": -20,
				"escape": 50,
				"next": "ending"
			}
		]
		
	},
	"escape_check": {
		"speaker": "PID-0001 [INIT_LOVE]",
		"expression": "glitch",
		"text": "Did you just touch the escape key?!?! Don't leave me alone here in [b]seance_os[/b]... please",
		"choices": [
			{
				"label": "Sprint for exit",
				"affection": -10,
				"escape": 35,
				"next": "ending"
			},
			{
				"label": "Fine, ill stay for a bit",
				"affection": 10,
				"escape": -10,
				"next": "ending"
			}
		]
		
	},
	"ending": {
		"speaker": "SYSTEM // SEANCE_OS",
		"expression": "neutral",
		"text": "",
		"choices": [
			{
				"label": "Replay Date",
				"affection": 0,
				"escape": 0,
				"next": "restart"
			}
		]
		
	}
}
func _ready() -> void:
	phantom_name_label.text = "PHANTOM // PID-0001"
	dialogue_text.bbcode_enabled = true
	affection_bar.min_value = 0
	affection_bar.max_value = 100
	escape_meter.min_value = 0
	escape_meter.max_value = 100
	_show_node("start")
func _show_node(node_id: String) -> void:
	if node_id == "restart":
		affection = 50
		escape = 20
		_show_node("start")
		return
	current_node_id = node_id
	var node: Dictionary = dialogue[node_id]
	
	affection = clampi(affection, 0, 100)
	escape = clampi(escape, 0, 100)
	affection_bar.value = affection
	escape_meter.value = escape
	speaker_label.text = node["speaker"]
	if node_id == "ending":
		dialogue_text.text = _resolve_ending_text()
	else:
		dialogue_text.text = node["text"]
	var expr_name: String = node.get("expression", "neutral")
	if expressions.get(expr_name) != null:
		portrait.texture = expressions[expr_name]
	for child in choices_box.get_children():
		child.queue_free()
	for choice in node["choices"]:
		var btn := Button.new()
		btn.text = choice["label"]
		btn.pressed.connect(_on_choice_pressed.bind(choice))
		choices_box.add_child(btn)
func _on_choice_pressed(choice: Dictionary) -> void:
	affection += int(choice.get("affection", 0))
	escape += int(choice.get("escape", 0))
	_show_node(choice["next"])
func _resolve_ending_text() -> String:
	if escape >= 75:
		return "[color=#4ade80][b]ENDING: CLEAN ESCAPE[/b][/color]\nYou got out of the haunted session before PID-0001 could lock the TTY."
	elif affection >= 75:
		return "[color=#f472b6][b]ENDING: DAEMON SOULMATE[/b][/color]\nYou became PID-0001's favorite child process. Uptime: infinite."
	else:
		return "[color=#facc15][b]ENDING: AWKWARD HANGUP[/b][/color]\nA lukewarm conneciton. PID-0001 sighs in hex and goes back to idling."
