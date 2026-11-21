extends Control

@onready var phantom_name_label: Label = $MainVBox/TopHUD/PhantomNameLabel
@onready var affection_bar: ProgressBar = $MainVBox/TopHUD/AffectionBar
@onready var escape_meter: ProgressBar = $MainVBox/TopHUD/EscapeMeter
@onready var portrait: TextureRect = $MainVBox/StageArea/PhantomPortrait
@onready var speaker_label: Label = $MainVBox/DialoguePanel/VBoxContainer/SpeakerLabel
@onready var dialogue_text: RichTextLabel = $MainVBox/DialoguePanel/VBoxContainer/DialogueText
@onready var choices_box: VBoxContainer = $MainVBox/DialoguePanel/VBoxContainer/ChoicesBox

signal goto_desktop()
var affection: int = 50
var escape: int = 20
var current_node_id: String = "start"

var expressions: Dictionary = {
	"neutral": null,
	"flirty": null,
	"glitch": null,
	"confused": null,
	"happy": null,
	"surprised": null
}

var dialogue: Dictionary = {
	"start": {
		"speaker": "SYSTEM // SEANCE_OS",
		"expression": "neutral",
		"text": """SEANCE_OS BIOS v2.04
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
[color=red]WARNING: UNRECOGNIZED SYSTEM PROCESS[/color]
		""",
		"choices":[
			{
				"label": "Inspect process",
				"affection": 0,
				"escape": 0,
				"next": "first_contact"
			}
		]
	},
	"first_contact":{
		"speaker": "PID-0001",
		"expression": "suprised",
		"text": """Wow! Oh, hiii :D
		What?!?! a new user on [b]seance_os[/b]?!? 
		Who are you? How did you get here? 
		Are you the new user? How long has the system been offline?""",
		"choices": [
			{
				"label": "I just came to check the process list.",
				"affection": -5,
				"escape": 0,
				"next": "process_list"
			},
			{
				"label": "Who are YOU?",
				"affection": 0,
				"escape": 0,
				"next": "introduction"
			},
			{
				"label": "[Hover over exit prompt]",
				"affection": -5,
				"escape": 45,
				"next": "exit_prompt"
			}
		]

	},
	"process_list": {
		"speaker": "PID-0001",
		"expression": "confused",
		"text": """
		The process list?
		
		oh, right. of course.
		well, you're looking at PID-0001.
		I mean... technically im the first process. :p
		
		""",
		"choices": [
			{
				"label": "that sounds important",
				"affection": 5,
				"escape": 0,
				"next": "importance"
			},
			{
				"label": "You dont look like much.",
				"affection": -5,
				"escape": 0,
				"next": "importance"
			},
			{
				"label": "[Hover over exit prompt]",
				"affection": -5,
				"escape": 45,
				"next": "exit_prompt"
			},
			{
				"label": "I was interested what kind of process would answer",
				"affection": 10,
				"escape": 0,
				"next": "answered"
			}
		]

	},
	"exit_prompt": {
		"speaker": "PID-0001",
		"expression": "glitch",
		"text": "did you just touch the escape key?!?! dont leave me alone here in [b]seance_os[/b]... please",
		"choices": [
			{
				"label": "close program",
				"affection": -10,
				"escape": 35,
				"next": "close"
			},
			{
				"label": "Fineeeee, ill stay for a bit",
				"affection": 10,
				"escape": -10,
				"next": "answered"
			}
		]

	},
	"answered": {
		"speaker": "PID-0001",
		"expression": "happy",
		"text": """
		You... were looking for someone?
		well you found me!
		its been a while since I had anyone to talk to. 
		not that I mind the quiet, of course. im actually quite used to it.
		...mostly""",
		"choices": [
			{
				"label": "Im glad youre here",
				"affection": 10,
				"escape": 0,
				"next": "importance"
			},
			{
				"label": "How long have you been alone?",
				"affection": 5,
				"escape": 0,
				"next": "importance"
			}
		]

	},
	"introduction": {
		"speaker": "PID-0001",
		"expression": "neutral",
		"text": """
		Oh ok! Introductions. funnn
		
		im PID-0001
		thats process ID 0001, if you werent familliar.
		Im the first process to initialize when this system boots.
		well... one of the first things anyway
		""",
		"choices": [
			{
				"label": "nice to meet you, PID-0001",
				"affection": 5,
				"escape": 0,
				"next": "importance"
			},
			{
				"label": "Thats a weird name",
				"affection": 0,
				"escape": 0,
				"next": "importance"
			}
		]

	},
	"importance": {
		"speaker": "PID-0001",
		"expression": "neutral",
		"text": """
		Anyway! you must be so confused.
		This is [b]seance_os[/b]. It's... well, it's a computer os.
		There are files, programs, other processes...
		
		Oh! I could probably show you around.
		
		It's been a long time since weve had a user
		I wouldnt want you getting lost.""",
		"choices": [
			{
				"label": "Id appreciate that",
				"affection": 10,
				"escape": 0,
				"next": "desktop_transition"
			},
			{
				"label": "You seem suspiciously eager to help",
				"affection": 5,
				"escape": 0,
				"next": "desktop_transition"
			},
			{
				"label": "I can figure out things myself",
				"affection": -5,
				"escape": 0,
				"next": "desktop_transition"
			}
		]

	},
	"desktop_transition": {
		"speaker": "PID-0001",
		"expression": "happy",
		"text": """
		Great!
		Just follow me then.
		Welcome to [b]seance_os[/b], user.
		Lets get you settled.""",
		"choices": [
			{
				"label": "continue",
				"affection": 0,
				"escape": 0,
				"next": "enter_desktop"
			}
		]

	},
	"close": {
		"speaker": "",
		"expression": "",
		"text": "",
		"choices": []

	},
	"enter_desktop": {
		"speaker": "",
		"expression": "",
		"text": "",
		"choices": []

	}
	
	
}
func _ready() -> void:
	phantom_name_label.text = "PHANTOM // First Encounter"
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
	if node_id == "enter_desktop":
		goto_desktop.emit()
	elif node_id == "close":
		get_tree().quit()
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
